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

fn marion(e: u32) {
    for i in 1..e + 1 {
        let space = e - i;
        for _ in (0..space).rev() {
            print!(" ");
        }
        for _ in 0..i {
            print!("#");
        }
        print!(" ");
        for _ in 0..i {
            print!("#");
        }
        print!("\n");
    }
}

fn input() -> u32{
    let mut line  = String::new();
    std::io::stdin().read_line(&mut line).unwrap();
    let entry : u32 = line.trim().parse().unwrap();
    return entry;
}

fn main() {
    loop {
        print!("Enter a number between 1 and 8: ");

        let input = input();

        if (input > 0 && input <9) {
            marion(input);
            break;
        }
        else {
            print!("Out of range...");
        }
    }
}