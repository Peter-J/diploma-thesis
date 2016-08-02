# This project hosts:
Code written as a part of my diploma thesis.
This code utilizes RoadRunner to simulate Stochastic Reaction Networks, further more R is used to plot empiric densities.

The code in the additional files can be used to keep the simulation running based on a *cronjob* ([cronjob.sh](https://github.com/Peter-J/diploma-thesis/blob/master/cronjob.sh), no not an executable) and [keep-running.sh](https://github.com/Peter-J/diploma-thesis/blob/master/keep-running.sh). You should modify `USER` to be your username and / or path in both files.

There is code to simulate Stochastic Reaction Networks using [MATLAB](https://github.com/Peter-J/diploma-thesis/blob/master/MatlabSimBioSSA.m) and [R](https://github.com/Peter-J/diploma-thesis/blob/master/GillespieSSAusingR.R) aswell, but this was just written for comparison. **Do not expect these two files** ([MatlabSimBioSSA.m](https://github.com/Peter-J/diploma-thesis/blob/master/MatlabSimBioSSA.m) and [GillespieSSAusingR.R](https://github.com/Peter-J/diploma-thesis/blob/master/GillespieSSAusingR.R)) **to be maintained.**

###Todo:
- [ ] Add a link to the simulation data already created.
- [ ] Exchange the plot function in the Simulation_linux.py file to work

## How to contribute: 
* Open an [issue](https://github.com/Peter-J/diploma-thesis/issues) or
* Fork this project -> change it -> make a pull request.

#Licence goal/idea
This code has copyright protection owned by me or others. In cases where I am the copyright owner: get an intuition of what I am ok with, as stated here or ask me. In any other case: see Attribution below and ask them / read their licence. In doubt: It is your responsibility to have no doubt before doing anything that could infringe any copyright, or any law.

**This is not a licence, this is an idea for a licence.** I would prefere something in the range of:
* You can do pretty much what ever you want, but
* you have to attribute
* you have to use the same licence
* you have to publish your source code (e.g. using GitHub), if you publish anything (based on or using this code) and made any non obvious changes to the source code, i.e.:
 * obvious changes: almost anything above line 50 in the python files / changing the anitimony model or any parameter 
 * non obvious changes: adding / changing functionality 
* you may not get rich using this code, i.e.:
  * getting paid or being funded (e.g. as academic staff, scientist) and using it __is admissible__, even though using something for work is concidered commercial use.
  * win a prize  / file a patent for a drug / scientific discovery / software or whatever you developed, while using this code __without__ giving an adequate share to the guys from [sys-bio](https://github.com/sys-bio), any contributor to this project and  me __is not admissible__.
  * selling anything that was developed while using this code or based on this code __without__ giving an adequate share to the guys from [sys-bio](https://github.com/sys-bio), any contributor to this project and  me __is not admissible__.

What *adequate* is, should be negotiated upfront. If no agreement is found the mentioned cases above are __not admissible__. I am not greedy, I just think "If you are good at something, don't do it for free", being a good person does not pay your bills.

#Attribution / references:
* The python code is based on the [TelluriumTemplate.py](https://github.com/Peter-J/diploma-thesis/tree/master/Templates) which is automatically generated by the spyder editor in the Tellurium package from the [sys-bio guys.](https://github.com/sys-bio/tellurium/blob/c17337d50911ff9cc9a03885bfb4ecd24500f06f/spyder_mod/spyderlib/plugins/editor.py#L1474-L1497)
  * the traces of this template should be considered marginal
* Some lines of code in the Simulation_linux.py file are copy&paste from Tellurium. Those lines are marked with a suitable comment. Those lines should be the only difference between Simulation.py and Simulation_Linux.py.
* The MATLAB code is 95% based on https://de.mathworks.com/help/simbio/examples/comparing-ssa-and-explicit-tau-leaping-stochastic-solvers.html
* the GillespieSSAusingR.R code was written using the R integrated help `?ssa`, which is straight forward.

To my best efforts and knowledge, this attribution is complete in the following sense: Anything that an average programmer could not write in 60 seconds after 30 hours without sleep, is attributed or indeed written by me.

This attribution might be incomplete in the following sense: There are only finitely many ways to write a single line of code. We have the year 2016, chances are a single line of code (especially the short ones like `for ... in ..`) has been written by somebody else before.
#Disclaimer
I am not responsible for anything you do or assume, for anything that happens to you or anybody else, your surroundings, the equipment you use, your reputation or whatever. No matter if it is based on code in this project, this Readme-file or anything else.

If I write / say or by any other means of communication or telepathy state something that could be understood as `you have to` or something similar, I expect you to understand it as a suggestion and not as a permission to stop using your own brain / stop being liable on your own.

Especially: I do not grant, and never have I granted you explicit or implicit rights to anything. I am not a lawyer, I use my common sense and if you do so too, we will most likely never have any legal dispute. I will not get a lawyer to modify the above to be a real licence, I for myself think there are better things to spend money on.

Shorthand: Use your common sense.
