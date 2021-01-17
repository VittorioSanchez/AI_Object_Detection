
##### authors: benistant, galvao

# DETECTION SOFTWARE

## FILES LIST:

### CUSTOM PACKAGES:

* detectnet_camera_custom_siec_noCV2.py
* Detection_Thread.py
* ROS_publisher_Thread.py
* global_variables.py 
 

### MAINS:
* main.py

## HOW IT WORKS:

The main software is in "main.py".

All the other functions are split in the packages.

### global_variables.py
Contains all the variables to be used simultaneaously in different python files.
The class mutex_variable defines a structure with variables used for publishing in all the ROS topics. The topics are the following:

* detection: for the class identifier of detected objects.
* left, right, top, bottom: those 4 topics have the coordinates delimiting the object's position.
* /detection_node/image: for the images with bounding boxes drawn around each detected object.

This class also contains a Mutex for avoiding simultaneous modifications from different threads.
In this file is created the global variable pub, of this class, which is used in Detection_Thread for sending the object detection results to the respective topics.
Other global variables are used for measuring results in tests: The variables tab_delta_time_loop_human, tab_delta_time_loop_hurdles and tab_delta_time_loop_ROS are lists for registering the execution time for each thread. The variables loop_counter_human, loop_counter_hurdles and loop_counter_ROS count the number of loops executed in a test.

### detectnet_camera_custom_siec_noCV2.py
This file has all the functions to initialize CNNs and the video input.

The functions Multiped_Init and Hurdles_Init are responsible for initializing respectively multiped and ssd-mobilenet with the right arguments (no need to specify them when calling those functions), including the threshold for sending and displaying the detection. For the human detection (multiped) we use a low threshold, of 50%, because we prioritize reducing the number of false negatives. For the other hurdles we use a threshold of 80%.

The function Imageprocessing is responsible for capturing an image from the video source, sending it through the ROS topic and calling a neural network for processing it. It returns the detection results and the image with bounding boxes.

### Human_Detection.py
Contains everything related to the real implementation of both the human CNN and the hurdles CNN. It detects continuously and when it detects something it sets a detection flag and sends a ROS message on "detection" topic containing the identifier of the detected object. Also, independently of having detected an object or not, the thread sends the video frame with boxes drawn on it indicating the positions of the detected objects.

For the initialization, this class takes a single parameter "target", which is a string indicating what neural network shall be used. This parameter may have the values "human" or "hurdles".

The functions human_detection_to_ROS_number and hurdles_detection_to_ROS_number are responsible for converting the class identifiers from the outputs of each neural network to the corresponding identifiers to be used in the ROS topic. The classes and their corresponding class numbers for networks and ROS are in the file classes_training.txt


### ROS_publisher_Thread.py
Contains the class ROS_publisher, which corresponds to a thread that continuously sends at 100Hz a ROS message to say nothing was detected. It uses global variables for communicating with the detection threads. When detection_flag is set, it clears the flag and stops sending the no_detection ROS message for 5s.

### main.py
In the main file the two previous thread classes are imported. First the ROS Topic is created, then 3 threads are declared and run: the ROS publisher thread and 2 detection threads, one for humans and one for other hurdles.
