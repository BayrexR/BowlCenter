INSTRUCTIONS FOR FOR LOADING ETL PROJECT
--------
1) Click on link https://bowl-center.herokuapp.com/ 
2) Once you have navigated to the Welcome page, the ETL Report is located in the hamburger menu under API Docs>ETL Process
<br/><br/><br/>

Flask App Deployment
---------------------


Prepare your Flask App for Heroku deployment
----------
   Heroku needs a few more things than what we have on our locally hosted Flask apps to run. More specifically, we add a webserver dependency, create a requirements.txt file, and add a Procfile.
   
  **Webserver (gunicorn):**
   * Open the terminal and navigate to your root (top) app folder.
   * Activate your python environment.
      * $ source activate <yourEnvironmentName>
   * Run the following command to install gunicorn, a webserver dependency.
      * $ pip install gunicorn
   
  **requirements.txt:**
  
   Heroku needs to know your dependencies. That is accomplished by creating a requirements.txt file using the following steps:
   * Make sure you are still in your app's root directory and your python enviroment is still active. If not follow the first two items in the webserver step.
   * Runnig the following command takes a snapshot of all your app dependencies and creates the requirements.txt in your current directory. Heroku will reference this file to pull all dependencies into the app.
      * $ pip freeze > requirements.txt
      * You can run this command again to update your requirements.txt file if you add more dependencies to your app.
  
   **Procfile:**
   
   Heroku will need to know what and how to lauch the app. This file tells it exactly what webserver to use and what to launch.
   * Open your favorite code editor and navigate to your app root folder.
   * Create a file titled "Procfile" (do not add an extension!)
   * Insert the following into your Procfile"
      * web:gunicorn app:app (this assumes your Flask app uses app.py as you server file. Else use app:[yourFlaskAppFile])
       

Create a Heroku Account
--------------------
  First thing's first. You'll need a Heroku account in order to deploy your apps to their platform. Luckily, they have a free version.
   * Go to https://www.heroku.com/ and create a free account. Remember your username/password and keep them safe.
   * Once you are logged in, go to Dashboard > New > Create new app
      * Give your app a name and then click "create app"
   

Install Heroku CLI and Deploy your APP
--------------
  Heroku is a Platform as a Service (PaaS) that allows you to leverage third party infrastructure for your app deployments. Apps are deployed via git in terminal and can be managed via web browser. To accomplish this we need to install the Heroku CLI so we can run our CLI commands.
  
  **Install:**
   * Go to https://devcenter.heroku.com/articles/heroku-cli to download the file for your OS. Follow the installation instructions.
   
  **Sign in to Heroku CLI:**
   * Open your terminal and run the following commands to log into your Heroku account.
      * $ heroku login
         * Enter your username and password when prompted
   * Now create a remote connection to the Heroku servers using the following command
      * $ heroku git:remote -a [heroku-app-name]
      * This give you the ability to deploy your app via git push commands like so... git push heroku master
   * Perform you initial heroku commit by runnung...
      * git add .
      * git commit -am "Initial Heroku deployment."
      * git push heroku master
   
   
Notes
----------

Version control
---------------
  When developing using Heroku it is best to use the following workflow:
   * Start GitHub repo
   * Build a local working app (not necessarily a complete app just one that loads)
   * Create the Heroku app and add any required add-ons
   * Fork your original repo and give it a new name ex...[appName]-heroku (This will be the Heroku deployed version of your app with all your web configurations)
   * Deploy it to Heroku and get it working as it was locally
   * While working on your app, push updates to your [appName]-heroku GitHub (git push origin master) repo then deploy to Heroku (git push heroku master)
   

Databases
----------
  If your app uses a database you will need to add a database add-on in Heroku and modify your source code connection strings and queries to work with your new cloud hosted db. In this case we used the JawsDB MySQL Heroku add-on as our persistent storage solution.
  
  
Config files are your friend
-----------------------
  Maintain both local and deployed versions of your app in separate repos. This allows you to work on features on the local version (much faster), copy the working code to your files in the deployed repo, and push to Heroku to deploy. Use config files and variables for DBs, connection strings, and tables declared early in your code and imported anywhere needed. This way your config values are all located in one central location and can be easily modified when environments change.

Patience
----------
  Free Heroku accounts do not get priority when it comes to refreshng and up time. Be ready for the following:
  * It might take a couple of minutes for changes to reflect in your deplyed apps. This is the reason it is important to keep both local and deployed versions of your app repos. 
  * To save on resources, Heroku puts idle apps to sleep (unless you want to pay). No big deal. Your app will just take a few extra seconds wake up and serve content but will stay away for a while after.
  
Free Add-ons not always free
-----------
  Free Heroku add-ons are usually free to a point. After that they will start to charge your account so be careful and mindful of what you deploy and how you deply it.
