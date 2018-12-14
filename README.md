INSTRUCTIONS FOR FOR LOADING ETL PROJECT
--------
1)Click on link https://bowl-center.herokuapp.com/
2)Once you have navigated to the Welcome page, the ETL Report is located in the hamburger menu under API Docs>ETL Process


Flask App Deployment
---------------------

Prepare your Flask App for Heroku deployment
----------
   Heroku needs a few more things than what we have on our locally hosted Flask apps to run. More specifically, we add a webserver dependency, create a requirements.txt file, and add a Procfile.
   
   Webserver (gunicorn):
   * Open the terminal and navigate to your root (top) app folder.
   * Activate your python environment.
      * $ source activate <yourEnvironmentName>
   * Run the following command to install gunicorn, a webserver dependency.
      * $ pip install gunicorn
   
   requirements.txt:
   Heroku needs to know your dependencies. That is accomplished by creating a requirements.txt file using the following steps:
   * Make sure you are still in your app's root directory and your python enviroment is still active. If not follow the first two items in the webserver step.
   * Runnig the following command takes a snapshot of all your app dependencies and creates the requirements.txt in your current directory. Heroku will reference this file to pull all dependencies into the app.
      * $ pip freeze > requirements.txt
      * You can run this command again to update your requirements.txt file if you add more dependencies to your app.
  
    Procfile:
    Heroku will need to know what and how to lauch the app. This file tells it exactly what webserver to use and what to launch.
    *Open your favorite code editor and navigate to your app root folder.
    *Create a file titled "Procfile" (do not add an extension!)
    *Insert the following into your Procfile"
       *web:gunicorn app:app (this assumes your Flask app uses app.py as you server file. Else use app:<yourFlaskAppFile>)
       

Install Heroku CLI
--------------

