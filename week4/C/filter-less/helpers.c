#include "helpers.h"
#include <math.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    //Loop for y axis
    for (int y = 0; y < height; y++)
    {
        //Loop for x axis
        for (int x = 0; x < width; x++)
        {
            //Mean of Blue, Green, Red values
            int mean = round((image[y][x].rgbtBlue + image[y][x].rgbtGreen + image[y][x].rgbtRed) / 3.0);
            //Assign new values to Blue, Green, Red rounding the Mean to return int
            image[y][x].rgbtBlue = image[y][x].rgbtGreen = image[y][x].rgbtRed = mean;
        }
    }
    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    //Loop for y axis
    for (int y = 0; y < height; y++)
    {
        //Loop for x axis
        for (int x = 0; x < width; x++)
        {
            //Sepia formula:
            //sepiaRed = .393 * originalRed + .769 * originalGreen + .189 * originalBlue
            //sepiaGreen = .349 * originalRed + .686 * originalGreen + .168 * originalBlue
            //sepiaBlue = .272 * originalRed + .534 * originalGreen + .131 * originalBlue
            float sepiaBlue = .131 * image[y][x].rgbtBlue + .534 * image[y][x].rgbtGreen + .272 * image[y][x].rgbtRed;
            float sepiaGreen = .168 * image[y][x].rgbtBlue + .686 * image[y][x].rgbtGreen + .349 * image[y][x].rgbtRed;
            float sepiaRed = .189 * image[y][x].rgbtBlue + .769 * image[y][x].rgbtGreen + .393 * image[y][x].rgbtRed;
            //Assign new values to Blue, Green, Red rounding the Sepia new values to return int value to assign
            //If is checking the values not to be more than 255, if yes just assign 255 as value
            if (round(sepiaBlue) > 255)
            {
                image[y][x].rgbtBlue = 255;
            }
            else
            {
                image[y][x].rgbtBlue = round(sepiaBlue);
            }
            if (round(sepiaGreen) > 255)
            {
                image[y][x].rgbtGreen = 255;
            }
            else
            {
                image[y][x].rgbtGreen = round(sepiaGreen);
            }
            if (round(sepiaRed) > 255)
            {
                image[y][x].rgbtRed = 255;
            }
            else
            {
                image[y][x].rgbtRed = round(sepiaRed);
            }
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    //Swapper will store temp x, y for the swap
    RGBTRIPLE swapper;
    //Loop for y axis
    for (int y = 0; y < height; y++)
    {
        //Loop for x axis
        for (int x = 0; x < width / 2; x++)
        {
            //Assign the current position of y on x axis
            swapper = image[y][x];
            //Reflect the position on x axis
            image[y][x] = image[y][width - x - 1];
            //Assign to swapper the new position of y on x axis
            image[y][width - x - 1] = swapper;
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    //State will store temp x, y for further use
    RGBTRIPLE state[height][width];
    //Loop for y axis for the STATE
    for (int y = 0; y < height; y++)
    {
        //Loop for x axis
        for (int x = 0; x < width; x++)
        {
            //Store the current y, x values
            state[y][x] = image[y][x];
        }
    }
    //Loop for y axis for BLUR
    for (int y = 0; y < height; y++)
    {
        //Loop for x axis for BLUR
        for (int x = 0; x < width; x++)
        {
            //Declare variables to store sum for colors and counter
            int sumBlue = 0;
            int sumGreen = 0;
            int sumRed = 0;
            float counter = 0.00;
            //Looping a "3x3" box to blur from initial y, x values
            for (int yy = -1; yy < 2; yy++)
            {
                for (int xx = -1; xx < 2; xx++)
                {
                    //Checking out of the box cases, edges and corners as well
                    if ((y + yy) < 0 || (y + yy) > (height - 1) || (x + xx) < 0 || (x + xx) > (width - 1))
                    {
                        continue;
                    }
                    //Summing the values of colors and increase the counter
                    sumBlue += image[y + yy][x + xx].rgbtBlue;
                    sumGreen += image[y + yy][x + xx].rgbtGreen;
                    sumRed += image[y + yy][x + xx].rgbtRed;
                    counter++;
                }
            }
            //Rounding the mean of colors and assign new values to image
            state[y][x].rgbtBlue = round(sumBlue / counter);
            state[y][x].rgbtGreen = round(sumGreen / counter);
            state[y][x].rgbtRed = round(sumRed / counter);
        }
    }
    //Assign current state of image colors to return as original
    //Loop for y axis
    for (int y = 0; y < height; y++)
    {
        //Loop for x axis
        for (int x = 0; x < width; x++)
        {
            //Change the current colors state to original image
            image[y][x].rgbtBlue = state[y][x].rgbtBlue;
            image[y][x].rgbtGreen = state[y][x].rgbtGreen;
            image[y][x].rgbtRed = state[y][x].rgbtRed;
        }
    }
    return;
}
