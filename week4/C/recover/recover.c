#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
//define the sizes of blocks and filename
#define BLOCKSIZE 512
#define FILENAMESIZE 8

int main(int argc, char *argv[])
{
    //Check the terminal input. If there are more or less arg print Run: ....
    if (argc != 2)
    {
        printf("Run: ./recover image\n");
        return 1;
    }
    //Open the file with fopen (with the flag READ) taking 1st entry as a file name
    FILE *fileOp = fopen(argv[1], "r");
    //If there is an empty file return an error
    if (fileOp == NULL)
    {
        printf("Error opening the file: \n");
        return 2;
    }
    //Declare a buffer with the size 512
    uint8_t buffer[BLOCKSIZE];
    //Declare a counter for images
    int counter = 0;
    //In memory file saver
    FILE *fileSv = NULL;
    //Allocate memory for filename with malloc (see task instructions)
    char *filename = malloc(FILENAMESIZE * sizeof(char));
    //While loop to find jpegs
    while (fread(buffer, BLOCKSIZE, 1, fileOp))
    {
        //Byte checker for the jpg pattern from task
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff && (buffer[3] & 0xf0) == 0xe0)
        {
            //Closing the written files
            if (counter > 0)
            {
                fclose(fileSv);
            }
            //assign the name to the new file using the counter
            sprintf(filename, "%03i.jpg", counter);
            //Open in memory file using the new filename and the write flag
            fileSv = fopen(filename, "w");
            //Write to file
            fwrite(buffer, BLOCKSIZE, 1, fileSv);
            //moving to the next image
            counter++;
        }
        //If the file is not empty
        else if (fileSv != NULL)
        {
            //Continue wite to file
            fwrite(buffer, BLOCKSIZE, 1, fileSv);
        }
    }
    //Empty allocated memory for filename (task instructions)
    free(filename);
    //Close the open file waiting to be written
    fclose(fileSv);
    //Close the raw opened file
    fclose(fileOp);
    return 0;
}