# QDA
library(MASS)
library(corrplot)
# ----- use the package
face.pca <- prcomp(t(face))  # should i use transpose or not?
summary(face.pca)
plot(face.pca)
dim(face.pca$x)  # 200 by 200
dim(face.pca$rotation)  # 10000 by 200
rotation <- face.pca$rotation  # essentially the eigenvector


pc1 <- t(face) %*% face.pca$rotation[, 1]
pc2 <- t(face) %*% face.pca$rotation[, 2]
pc3 <- t(face) %*% face.pca$rotation[, 3]
pc4 <- t(face) %*% face.pca$rotation[, 4]
pc5 <- t(face) %*% face.pca$rotation[, 5]



# form the label
pc <- data.frame(pc1, pc2, pc3, pc4, pc5, factor(c(rep(1, 100), rep(2, 100))))
colnames(pc) <- c('pc1', 'pc2', 'pc3','pc4', 'pc5', 'gender')
head(pc)



# check the covariance based on group
pc.m <- cov(pc[1:100, 1:5])
pc.f <- cov(pc[101:200, 1:5])
# not equal
wb <- c("white","black")
corrplot(pc.m, is.corr = F, col=wb, bg="grey90", tl.pos = 'n')
title(main = 'Covariance for Male')
corrplot(pc.f, is.corr = F, col=wb, bg="grey90", tl.pos = 'n')
title(main = 'Covariance for Female')

corrplot(cov(pc[, 1:5]), is.corr = F, col=wb, bg="grey90", tl.pos = 'n')
title(main = 'Covariance for 5 pc, both genders')


corrplot(cov(pc[, 1:5]), is.corr = F, method = 'circle')


# ------------------- qda
face.qda <- qda(pc[, -6], pc$gender)
pred.qda <- predict(face.qda)$class
predict(face.qda)$posterior


misclass2 <- function(prediction){
  pred.male <- prediction[1:100]
  pred.female <- prediction[101:200]
  
  misclass <- length(which(pred.male == 2)) + length(which(pred.female ==1))
  mrate <- misclass/200
  return(mrate)
}
misclass2(pred.qda)   # 0.085

# ---------------- plot against two sets

# plot against gender
par(mar = c(4, 4, 3, 1))
plot(pc1, pc2, col = pc$gender, pch = 17, xlab = 'PC1', ylab = 'PC2')
title(main = 'Decision boundary, PC1, 2')
legend('bottomleft', legend = c('All PC', 'PC1, PC2'), lty = c(1, 2), 
     lwd = 2, box.lty=0)
plot(pc1, pc3, col = pcs$gender, pch = 17, xlab = 'PC1', ylab = 'PC3')
title(main = 'Decision boundary, PC1, 3')
legend('bottomleft', legend = c('All PC', 'PC1, PC3'), lty = c(1, 2), 
       lwd = 2, box.lty=0)




# draw discrimination line
# use contour package
np <- 300
nd.x <- seq(from = -100, to = 100, length.out = np)
nd.y <- seq(from = -100, to = 100, length.out = np)
nd <- expand.grid(X1 = nd.x, X2 = nd.y)   # 90000 points
dim(nd)

pc4null <- pc5null <- pc2null <- pc3null <- rep(0, 90000)

# predict for pc1, 2
new12 <- data.frame(nd, pc3null, pc4null, pc5null)
colnames(new12) <- c('pc1', 'pc2', 'pc3','pc4', 'pc5')
dim(new12)



# this one is for 5 col
prd12 <- as.numeric(predict(face.qda, newdata = new12)$class)
contour(x = nd.x, y = nd.y, z = matrix(prd12, nrow = np, ncol = np), 
        levels = c(1, 2), add = TRUE, drawlabels = F, lwd = 2)
# this one for pc1, 2 only
qda12 <- qda(pc[,1:2], pc$gender)
prd122 <- as.numeric(predict(qda12, newdata = nd)$class)
contour(x = nd.x, y = nd.y, z = matrix(prd122, nrow = np, ncol = np), 
        levels = c(1, 2), add = TRUE, drawlabels = F, lty = 2, lwd = 2)



# predict for pc1, 3
new13 <- data.frame(nd[, 1], pc2null, nd[, 2], pc4null, pc5null)
colnames(new13) <- c('pc1', 'pc2', 'pc3','pc4', 'pc5')
head(new13)
prd13 <- as.numeric(predict(face.qda, newdata = new13)$class)
contour(x = nd.x, y = nd.y, z = matrix(prd13, nrow = np, ncol = np), 
        levels = c(1, 2), add = TRUE, drawlabels = F, lwd = 2)

qda13 <- qda(matrix(c(pc[, 1], pc[, 3]), 200, 2), pc$gender)
prd132 <- as.numeric(predict(qda13, newdata = nd)$class)
contour(x = nd.x, y = nd.y, z = matrix(prd132, nrow = np, ncol = np), 
        levels = c(1, 2), add = TRUE, drawlabels = F, lty = 2, lwd = 2)










