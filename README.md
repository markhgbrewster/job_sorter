# Job Sorter

###Assumptions
  I am assuming that a new line will separate each job paring in the string.

###Notes
  I began by converting the string into a hash, as it is easier to manipulate the job Data in that format. 
  
  It became clear that it would be beneficial to have each job as a job object. So I looped through the jobs hash and create each job as an instance of the Job Class. This enabled me to collate these jobs into an array of Job objects that I can map through to find jobs the match certain conditions.
  
  I decided to look at the job dependency relationship as a parent child similar to the ones created by the acts_as_tree gem (https://github.com/amerine/acts_as_tree) - with the parent being a job the job is dependant on.
  Once I have all the job objects in the array. I select only the ones that are roots (eg. are not depend on any other job) to the output string and a then add their children   (the jobs the are dependent on them). After that I loop through the jobs that are not roots add them and their children to the out put string unless they are already in it.  
  
  To handle self-dependencies it counts the number of jobs that are the same as their parent and if it is equal greater than one it raises an exception. 
  
  To handle the circular dependencies it collates the jobs into a hash with the job as a key and the value being an array of the jobs it is dependant on  (e.g. parents and grand parents etc). If the value array of any of these hash keys contains that key it raises a error. I did it this was it will catch deeper circular dependencies than the one described in the scenario.

###Tests
  I have user RSpec for the tests. 

  I have based most of the tests on the scenarios provided, however, I have added so other test that document other scenarios as to make sure it is working 100%.

  To run the tests enter rspec in the command line  
