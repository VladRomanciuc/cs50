//task: build:
//        #
//       ##
//      ###
//     ####
//    #####
//   ######
//  #######
// ########

//task2: build:
//        # #
//       ## ##
//      ### ###
//     #### ####
//    ##### #####
//   ###### ######
//  ####### #######
// ######## ########


//main function
fn main() {


println!("Enter a number between 1 and 8: ");

//variable to store the user input
let input = input();

//condition checker for user input between 1 and 8
if input > 0 && input <9 {
    //Call the marion function passing the user input
    marion(input);
    }
else {
    //if outside of range print info
    println!("Out of range...");
    }
}

//function to take the input from user and return the entry as a number
fn input() -> u32{
    //variable line of type string
    let mut line  = String::new();
    //call the terminal reader
    std::io::stdin().read_line(&mut line).unwrap();
    //trimm the entry for spaces and trnsform to number
    let entry : u32 = line.trim().parse().unwrap();
    return entry;
}

//The pyramid builder function
fn marion(e: u32) {
    //starts from a new line
    print!("\n");
    //for loop starts with 1 for math calculations
    for i in 1..e + 1 {
        //calculate the empty spaces required
        let space = e - i;
        //print empty spaces
        for _ in (0..space).rev() {
            print!(" ");
        }
        //print hashes
        for _ in 0..i {
            print!("#");
        }
        //print empty space for second task
        print!(" ");
        //print hashes
        for _ in 0..i {
            print!("#");
        }
        //move to new line
        print!("\n");
    }
}