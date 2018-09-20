# Introduction
This was my quick attempt at implementing the Merkleville social engineering experiment in https://www.i-programmer.info/programmer-puzzles/sharpen-your-coding-skills/6422.html  

# Usage
```julia
using PyPlot
using Merkleville
callback(town) = (plt[:gca]()[:clear]();imshow(town.A))

town = Merkleville.rand(Merkleville.Town, 500,500)
Merkleville.simulate!(town,4,1500,callback)
```
