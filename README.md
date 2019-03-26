# Indentify_3D_Surface_NeuralNetworks
The principal curvatures of 3-D surface is selected as learning feature for neural networks. PREMONN (PREdictive MOdular Neural Networks) is the architecture of neural networks. In this technique many of simple neural networks are developed and trained in a small area of surface, instead of one big neural network in total surface. 
## Summary of files and explanation
1. finalAlgorithm.m -> Call functions, initialize parameters, load data
2. extractLN.m -> return 2 principal curvature and curvature directions of nodes in 3-D surface
3. LeastSquareErrorEstimate.m -> return function estimation of LSE method
4. curvature.m -> compute principal curvatures and curvature directions in specific point
5. findSurface.m -> find surfaces (Ax+By+C) which are perpedicular in this specific point
6. increaseX.m -> return nodes in line of curvatures moving with increasing step in x axis 
7. decreaseX.m -> return nodes in line of curvatures moving with decreasing step in x axis
8. findVerticalUp.m -> find nodes in vertical direction in one direction
9. findVerticalDown.m -> find nodes in vertical direction in opposite direction
10. gridCreationVertical.m -> return node in one direction
11. gridCreationHorizontal.m -> return node in opposite direction
12. createNeuralNet.m -> create and train simple neural network (1 hidden layer with 10 hidden neurons)
13. trainTestMerge.m -> return merged neural networks
14. 
