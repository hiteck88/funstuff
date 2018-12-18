# ------------- 2-d ts

install.packages('astsa')
library(astsa)
data(soiltemp)    # 64 by 36 matrix of surface soil temperatures
soiltemp

persp(1:64, 1:36, soiltemp, phi = 30, theta = 30, scale = FALSE, 
      expand = 4, ticktype = 'detailed', xlab = 'rows', ylab = 'columns', 
      zlab = 'temperature')
# phi == colatitute direction (above)
# theta == azimuthal direction (side)
# 30, 30 is the best combination
plot.ts(rowMeans(soiltemp), xlab = 'row', ylab = 'average temp')
plot.ts(colMeans(soiltemp), xlab = 'col', ylab = 'average temp')




