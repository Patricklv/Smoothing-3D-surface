library(geomorph)
library(xlsx)
library(rgl)

# The vb, it, and col object below are exported from Matlab
vb <- read.xlsx("E:\\Research\\GM\\3D started\\Spatially dense\\Point cloud to mesh\\vb.xlsx", sheetIndex = 1, header = F)
it <- read.xlsx("E:\\Research\\GM\\3D started\\Spatially dense\\Point cloud to mesh\\it.xlsx", sheetIndex = 1, header = F)
col <- read.xlsx("E:\\Research\\GM\\3D started\\Spatially dense\\Point cloud to mesh\\col.xlsx", sheetIndex = 1, header = F)

vb_mat <- t(as.matrix(vb))
vb_mat <- rbind(vb_mat, 1)
rownames(vb_mat) <- c("xpts", "ypts", "zpts", "")

it_mat <- t(as.matrix(it))
rownames(it_mat) <- NULL

vertices <- c(vb_mat)
indices <- c(it_mat)

# Transpose col data
col_mat <- t(as.matrix(col))
rownames(col_mat) <- NULL

# convert RGB to hex code for each vertex
col_hex <- NULL

for (i in 1:dim(col_mat)[2]) {
    col_hex[i] <- rgb(col_mat[1,i], col_mat[2,i], col_mat[3,i])
}

# Associate each vertex of each face with hex color code
col_hex_mat <- matrix(NA, nrow = dim(it_mat)[1], ncol = dim(it_mat)[2])
for (i in 1:dim(it_mat)[1]){
    for (j in 1:dim(it_mat)[2]){
col_hex_mat[i,j] <- col_hex[it_mat[i,j]]
    }
}

col_hex_mat <- list(color = col_hex_mat)

try <- tmesh3d(vertices = vertices, indices = indices, homogeneous = TRUE, material = col_hex_mat, 
			   normals = NULL, texcoords = NULL)

try2 <- addNormals(try)

shade3d(try2, col="darkgrey", specular = "#202020")