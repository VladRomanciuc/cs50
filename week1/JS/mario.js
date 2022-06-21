const prompt = require("prompt-sync")();
//task: build:
//        #
//       ##
//      ###
//     ####
//    #####
//   ######
//  #######
// ########


function mario() {
    //start a forever loop to read the entry of the user
    for (let g = 0; g >= 0; g++) {
        var input = prompt("Enter a number between 1 and 8:");
        //check if entry is between 1 and 8
        if (input >= 1 && input <= 8) {
            var line = 1;
            //builder
            if (line <= input) {
                var space = input - line;
                //print empty spaces
                for (let sp = space; sp >0; sp--) {
                    console.log(" ");
                    };   
                //print #
                for (let i = input; i > space; i--){
                    console.log("#");
                    };
                console.log("\n");
            //go to next line
            line++;
            }
        }
    }
}

let x = mario();
console.log(x);