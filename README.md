# Pre-interview
My name is Gordie Novak!  
*One very fun* fact about me is that I've had a lot of knee surgery. (Very fun)

## Running the Program
*Note: You need the zsh shell to run this program.*  
**If you don't have the zsh shell installed on your system, you can follow the helpful instructions on the [Oh my ZSH! Github](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH#how-to-install-zsh-on-many-platforms)*  

To run the program, simply run the executable in the ```src``` directory titled: 
```query-runner.zsh```.  
  
Upon initialization, you will be asked to provide the path to your ```cvc5``` executable and a folder containing your ```.smt2``` files. 
You must provide the Path from the ROOT directory, and cannot use the ``` ~ ``` symbol,  you must type it out manually (*sorry*).  

### Project Assets
This project will need some other files in the current repository, stored in the ```assets``` directory.
- ```cvcPath.txt``` stores the path to your cvc5 executable
- ```queryPath.txt``` stores the path to your query folder *(editable within the program)*
- ```results.csv``` stores a csv. files of the results of each query run. *(writes over itself each time the program runs)*









