images_ch = Channel.fromPath("${params.inputDir}/*.tif")
images_ch.view()

//Images Copy
process COPY {
input:
path(image_ch)
output:
path("*_copy.tif")

script:
"""
cp ${image_ch} ${image_ch.baseName}_copy.tif
"""

}

//CellPose Segmentation
process SEGMENT_CELLPOSE{
publishDir "cellpose_Results", mode:'copy', overwrite: true
input:
path(image)
output:
path("*.tif")

script:
"""
echo "Segmenting image ${image.baseName} with Cellpose"
cellpose --image_path ${image}  --save_tif --use_gpu
"""

}

//Workflow Block
workflow{
copy_out_ch = COPY(images_ch)
cellpose_out_ch = SEGMENT_CELLPOSE(copy_out_ch)
}
