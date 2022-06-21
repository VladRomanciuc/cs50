//to read the input from user
const prompt = require("prompt-sync")();
//string builder
const StringBuilder = require("string-builder");
//chalk to color the hashes
const chalk = require('chalk');
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


function mario() {
    //declare a string builder
    const sb = new StringBuilder();
    //read the entry of the user
    var input = prompt("Enter a number between 1 and 8:");
    //Check if the input is between 1 and 8 
    if (input >= 1 && input <= 8) {
        //for loop starting to build from line 1
        for (let line = 1; line <= input; line++) {
        //counters for empty space and hashes
        var space = input - line;
        var hash = input - space;
        //builder
            for (var s = 1; s <= space; s++) {
                sb.append(" "); 
            };
            for (var i = 1; i <= hash; i++) {
                sb.append("#");
            }; 
            sb.append(" "); 
            for (var i = 1; i <= hash; i++) {
                sb.append("#");
            }; 
            //Print line 
            console.log(chalk.redBright(sb.toString()));
            //clear the builder
            sb.clear();
        }
    }
}
//required to run the function in terminal
console.log(mario());