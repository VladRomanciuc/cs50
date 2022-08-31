import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    # Get the user id from current session
    user_id = session["user_id"]
    # Get all stock from transactions table from DB, sum the total amount of shares grouping by "symbol"
    stocks = db.execute(
        "SELECT share_name, SUM(share_amnt) as total_amnt, share_price, symbol FROM transactions WHERE user_id = ? GROUP BY symbol;", user_id)
    # Get current amount of cash from users table
    current_cash = db.execute("SELECT cash FROM users WHERE id = ?;", user_id)[0]["cash"]
    # Variable to store the initial cash
    total_cash = current_cash
    # Add the value of shares for the total balance
    for s in stocks:
        total_cash = total_cash + s["share_price"] * s["total_amnt"]
    # return the index page passing variable to use in html markup
    return render_template("index.html", stocks=stocks, current_cash=current_cash, total_cash=total_cash, usd=usd)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    ## Create new table transactions
    ## New table schema transactions (id, user_id, share_name, share_amnt, share_price, trans_type, symbol, trans_time)
    ## SQL code to execute on db manually
    ## CREATE TABLE transactions (
    # id INTEGER PRIMARY KEY AUTOINCREMENT,
    # user_id INTEGER NOT NULL,
    # share_name TEXT NOT NULL,
    # share_amnt INTEGER NOT NULL,
    # share_price NUMERIC NOT NULL,
    # trans_type TEXT NOT NULL,
    # symbol TEXT NOT NULL,
    # trans_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    # FOREIGN KEY(user_id) REFERENCES users(id));

    # Get the user id from current session
    user_id = session["user_id"]
    # Check for the http method
    if request.method == "POST":
        # Get value of stock from html form
        stock = request.form.get("symbol").upper()
        # Using lookup to get info for the stock
        getStock = lookup(stock)

        # if stock is empty or info about the stock is empty return error
        if not stock:
            return apology("Symbol required")
        elif not getStock:
            return apology("Symbol missing")
        # Get the share amount from form and handle the error
        try:
            share_amnt = int(request.form.get("shares"))
        except:
            return apology("Shares have to be int number")
        # Value checker if the number is negative (to pass cs50 check) as it was handled in form
        if share_amnt <= 0:
            return apology("Shares have to be positive int number")
        # Get the cash amount from users table
        user_cash = db.execute("SELECT cash FROM users WHERE id= ?;", user_id)[0]["cash"]
        # Get the share name from return of lookup
        share_name = getStock["name"]
        # Get the share price from return of lookup
        share_price = getStock["price"]
        # Set the transaction type to buy
        trans_type = "buy"
        # Estimate te cash amount to be paid
        totalCashNeeded = share_price * share_amnt
        # Estimate the cash left on user account
        user_cash_left = user_cash - totalCashNeeded

        # If the requested amount is greated than actual balance return error
        if user_cash < totalCashNeeded:
            return apology("Need more available cash")
        else:
            # Record the transaction in transactions table
            db.execute(
                "INSERT INTO transactions (user_id, share_name, share_amnt, share_price, trans_type, symbol) VALUES (?, ?, ?, ?, ?, ?);", user_id, share_name, share_amnt, share_price, trans_type, stock)
            # Update the new cash amount in the users table
            db.execute("UPDATE users SET cash = ? WHERE id = ?;", user_cash_left, user_id)
        return redirect("/")
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    # Get the user id from current session
    user_id = session["user_id"]
    # Get all transactions for the user from transactions table
    history = db.execute(
        "SELECT share_name, share_amnt, share_price, trans_type, symbol, trans_time FROM transactions WHERE user_id = ? ORDER BY trans_time DESC;", user_id)
    # Pass the history variable to html
    return render_template("history.html", history=history, usd=usd)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("Must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("Must provide password", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("Invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""
    # Forget any user_id
    session.clear()
    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    # If the http method is post
    if request.method == "POST":
        # Get stock from form
        stock = request.form.get("symbol")
        # If the form is empty return error
        if not stock:
            return apology("Share symbol is required.")
        # Get the stock info using the lookup function
        getStock = lookup(stock)
        # If the info is empty return error
        if not getStock:
            return apology("Valid entry for share symbol required.")
        # Show an updated html with the info grabed
        return render_template("quoted.html", entry=getStock, usd=usd)
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    # Check if the http method is post
    if request.method == "POST":
        # Get username, user password from form
        user_name = request.form.get("username")
        user_password = request.form.get("password")
        # If these are empty return error
        if not user_name:
            return apology("Enter a username, please.")
        elif not user_password:
            return apology("Enter a password, please.")
        # get the password confirmation from form
        pwd_confirmation = request.form.get("confirmation")
        # If it is empty return an error
        if not pwd_confirmation:
            return apology("Confirm the password, please.")
        # If the password do not match confirmation password return error
        if user_password != pwd_confirmation:
            return apology("Password and confirmation do not match.")
        # Encrypt password
        passHash = generate_password_hash(user_password)
        try:
            # Add the user name and the encrypted password in the users table, the id is autogenerated in DB
            db.execute("INSERT INTO users (username, hash) VALUES (?, ?);", user_name, passHash)
            return redirect("/")
        except:
            # Handle error
            return apology("User is registred already!")
    else:
        return render_template("registration.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    # Get the user id from current session
    user_id = session["user_id"]
    # Check if the http method is post
    if request.method == "POST":
        # Get stock from form
        stock = request.form.get("symbol")
        if not stock:
            return apology("Share symbol is required.")
        # Get the stock info using the lookup function
        getStock = lookup(stock)
        # If the info is empty return error
        if not getStock:
            return apology("Valid entry for share symbol required.")
        share_name = getStock["name"]
        # Get share price from info
        share_price = getStock["price"]
        # Get shares amount from form
        share_amnt_sell = int(request.form.get("shares"))
        # Get the amount of share the user own from transaction table grouping by symbol
        current_shares = db.execute(
            "SELECT share_amnt FROM transactions WHERE user_id = ? AND symbol = ? GROUP BY symbol;", user_id, stock)[0]["share_amnt"]
        # Get user cash from users table
        user_cash = db.execute("SELECT cash FROM users WHERE id= ?;", user_id)[0]["cash"]
        # Set transaction type to sell
        trans_type = "sell"
        # Check for negative amount entered (to pass cs50 check) handed in form
        if share_amnt_sell <= 0:
            return apology("Shares have to be positive int number.")
        # Check that the amount the user want to sell do not exceed the amount owned
        if current_shares < share_amnt_sell:
            return apology("The amount of shares to sell exceed the amount owned.")
        # Estimate the amount of cash to recieve
        totalCashToRecieve = share_price * share_amnt_sell
        # Estimate the amount of cash user own
        user_cash_left = user_cash + totalCashToRecieve
        # add the transaction to transactions table
        db.execute(
            "INSERT INTO transactions (user_id, share_name, share_amnt, share_price, trans_type, symbol) VALUES (?, ?, ?, ?, ?, ?);",
        user_id, share_name, -share_amnt_sell, share_price, trans_type, stock)
        # Update the cash user own in users table
        db.execute("UPDATE users SET cash = ? WHERE id = ?;", user_cash_left, user_id)
        return redirect("/")
    else:
        # If http method is get, get the symbols the user own to update the html
        symbols = db.execute("SELECT symbol FROM transactions WHERE user_id = ? GROUP BY symbol;", user_id)
        return render_template("sell.html", symbols=symbols)


@app.route("/resetpwd", methods=["GET", "POST"])
@login_required
def resetpwd():
    """Reset Password"""
    # Get the user id from current session
    user_id = session["user_id"]

    # If the http method is post
    if request.method == "POST":
        # Get old encrypted password from users table
        old_pwd_hash = db.execute("SELECT hash FROM users WHERE id = ?;", user_id)[0]["hash"]
        # Get the old and new password from form and confirmation of password as well
        old_pwd = request.form.get("oldpassword")
        new_pwd = request.form.get("newpassword")
        conf_pwd = request.form.get("confirmation")
        # If the entries are empty return suitable error
        if not old_pwd:
            return apology("Enter the old password, please.")
        if not new_pwd:
            return apology("Enter a new password, please.")
        if not conf_pwd:
            return apology("Confirm the new password, please.")
        # If the new password and confirmation do not match return an error
        if new_pwd != conf_pwd:
            return apology("New password and confirmation do not match.")
        # If the old password from from do not match with the encrypted password from db return error
        if check_password_hash(old_pwd_hash, old_pwd) == False:
            return apology("The old password do not match db records.")
        # Encrypt new password
        passHash = generate_password_hash(new_pwd)
        try:
            # update the new encrypted password in the users table and handle the error
            db.execute("UPDATE users SET hash = ? WHERE id = ?;", passHash, user_id)
            return redirect("/")
        except:
            return apology("Enter the old password first to proceed.")
    else:
        return render_template("reset.html")


@app.route("/addcash", methods=["GET", "POST"])
@login_required
def addcash():
    """Add Cash"""
    # Get user id from current session
    user_id = session["user_id"]
    # Get the current cash from users table
    current_cash = db.execute("SELECT cash FROM users WHERE id = ?;", user_id)[0]["cash"]
    # If the http method is post
    if request.method == "POST":
        # Get the cash amount to be added from form
        new_cash = int(request.form.get("newcash"))
        # Estimate the new amount the user have
        total_cash = current_cash + new_cash
        try:
            # Ipdate the cash amount in the users table and handle the error
            db.execute("UPDATE users SET cash = ? WHERE id = ?;", total_cash, user_id)
        except:
            return apology("DB connection fails.")
        # Get updated cash from users table and pass to html
        updated_cash = db.execute("SELECT cash FROM users WHERE id = ?;", user_id)[0]["cash"]
        return render_template("newcash.html", cash=updated_cash, usd=usd)
    else:
        return render_template("addcash.html", cash=current_cash, usd=usd)