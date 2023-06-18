import com.hamoid.*;

VideoExport videoExport;

int circle1X, circle1Y; // Position of circle 1
int circle1XSpeed = 6; // Speed of circle 1 in the x direction
int circle1YSpeed = 7; // Speed of circle 1 in the y direction

int circle2X, circle2Y; // Position of circle 2
int circle2XSpeed = 4; // Speed of circle 2 in the x direction
int circle2YSpeed = 5; // Speed of circle 2 in the y direction

int circleSize = 50; // Diameter of the circles

String csvPath = "bounding_box_coordinates.csv"; // File path for the CSV output

PrintWriter writer;

void writeToFile() {
  

    
    writer.print(circle1X - circleSize/2); // min_x_1
    writer.print(",");
    writer.print(circle1X + circleSize/2); // max_x_1
    writer.print(",");
    writer.print(circle1Y - circleSize/2); // min_y_1
    writer.print(",");
    writer.print(circle1Y + circleSize/2); // max_y_1
    writer.print(",");
    writer.print(circle2X - circleSize/2); // min_x_2
    writer.print(",");
    writer.print(circle2X + circleSize/2); // max_x_2
    writer.print(",");
    writer.print(circle2Y - circleSize/2); // min_y_2
    writer.print(",");
    writer.println(circle2Y + circleSize/2); // max_y_2
    

}

void setup() {
  
  writer = createWriter(csvPath);
  
  size(800, 600); // Set the size of the sketch window

  circle1X = width / 2; // Initialize the position of circle 1 to the center of the screen
  circle1Y = height / 2;
  circle2X = width / 2; // Initialize the position of circle 2 to the center of the screen
  circle2Y = height / 2;

  videoExport = new VideoExport(this);
  videoExport.setFrameRate(25);
  videoExport.startMovie();
}

void draw() {
  // Update the positions of circle 1
  circle1X += circle1XSpeed;
  circle1Y += circle1YSpeed;

  // Check if circle 1 has reached the boundaries of the screen
  if (circle1X + circleSize/2 >= width || circle1X - circleSize/2 <= 0) {
    circle1XSpeed *= -1; // Reverse the direction in the x axis
  }
  if (circle1Y + circleSize/2 >= height || circle1Y - circleSize/2 <= 0) {
    circle1YSpeed *= -1; // Reverse the direction in the y axis
  }

  // Update the positions of circle 2
  circle2X += circle2XSpeed;
  circle2Y += circle2YSpeed;

  // Check if circle 2 has reached the boundaries of the screen
  if (circle2X + circleSize/2 >= width || circle2X - circleSize/2 <= 0) {
    circle2XSpeed *= -1; // Reverse the direction in the x axis
  }
  if (circle2Y + circleSize/2 >= height || circle2Y -circleSize/2 <= 0) {
circle2YSpeed *= -1; // Reverse the direction in the y axis
}

// Draw circles
background(255); // Clear the screen
fill(255, 0, 0); // Red color

// Draw circle 1
ellipse(circle1X, circle1Y, circleSize, circleSize);

// Draw circle 2
ellipse(circle2X, circle2Y, circleSize, circleSize);

// Add frame to the movie
videoExport.saveFrame();

// Write bounding box coordinates to CSV
writeToFile();

// Stop the sketch after exporting the video
if (frameCount >= 300) { // Adjust the number of frames based on the desired length of the video
videoExport.endMovie();
writer.close();
exit();
}
}
