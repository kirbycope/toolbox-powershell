# Automated API Testing Using Powershell

# The Setup
I use the HttpClient (System.Net.Http.dll), included with this script. I also import the JSON.Net library (also included) to parse the JSON response from the RESTful API. The CSV file is what makes this a data-driven testing solution that is easily updated and read by both machine and man.

## What’s Going On
1. Get the Present Working Directory (pwd) and save it for the next few steps
2. Import the .dll files (see “The Setup” above)
3. Set the BaseUrl, so that only the endpoints need to be specified in the .CSV file
   - This allows you to easily switch environments
4. Create a new instance of the HttpClient
   - This will hold your session, so that you can log-in with one test and then do some call that requires a valid session afterwards
5. Import the .CSV file
6. Parse the .CSV file using a foreach loop
   1 . Create an error array
   2. Create a description of the current test (row of the .CSV)
   3. Build a request with the given data
      - If the Method is PUT or POST, then add the body content
   4. Send the request and save the response
   5. Save the response’s status code
   6. Save the response’s content
   7. If the expected status code does not match the response’s, then we add that error message to the error array
   8. If the error array has any length, then we print out an error (with red text-color)
      - Else, print out a success message (with green-text)
   9. If there is a comment in the .CSV file’s current row, then print that out (with gray-text)