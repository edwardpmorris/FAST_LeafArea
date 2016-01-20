#' Helper function to set up LeafArea run.ij
#'
#' As long as ImageJ application is installed in the follwoing directory, you do not have to specify the path to ImageJ
#' /Applications/ImageJ/ <Mac>
#' C:\Program Files\ImageJ\ <Windows>
#' Linux always needs to specify the path to ImageJ. For example, path = "~/ImageJ/"
#'
#'
#' @param set.directory Set directory that contains leaf images. 
#' @param trim.pixel Number of pixels removed from edges in the analysis.
#' @param check.image Do you want imageJ to open and show you the analysis of each image?
#' @param distance.pixel The number of pixels for the 'known.distance'
#' @param known.distance The distance for which 'distance.pixel' is known
#' @param path.imagej The path where the imageJ executable is found. For Linux this must be stated.
#'
#' @return A dataframe with filename and calculated 'projected surface area of element' (m2)
#' @export
#'
#' @examples
#' # if using Linux define the path to the ImageJ executable, if not, comment out.
#' # recommend download and extract the standalone version, rather than use a package manager.
#' path.imagej <- "~/ImageJ"
#' #path.image <- file.path(system.file("images", package="FAST_LeafArea"),"")
#' path.image <- "inst/images"
#' # for A4 paper 300 dpi; 21 cm = 1238 px 
#' area <- helper.leafarea(set.directory=path.image, path.imagej=path.imagej, trim.pixel=250, distance.pixel=1238, known.distance=21, check.image=F)
#' # write to file in working directory
#' write.csv(area, paste0(paste(attr(area,"standard.name"), attr(area,"units"), sep="_", ".csv")), quote = T, na = "NA", row.names = F)
#' 
helper.leafarea <- function (set.directory, trim.pixel=0, check.image=F, distance.pixel=1, known.distance=1, path.imagej=NULL) {
  # check LeafArea package is available
  require(LeafArea)
  # run imageJ using "standard FAST project settings"
  out <- run.ij(
      path.imagej = path.imagej
    , set.directory = set.directory
    , trim.pixel = trim.pixel
    , low.size = 5 # exclude small objects, has to be larger than scale bar (5 cm^2) 
    #, low.circ = 0.1
    , log = TRUE # this gives area for individual files
    , distance.pixel = distance.pixel # assume width of image is A4, 21cm, FIXME: make this automatic (look at EXIF?)
    , known.distance = known.distance # assume width of image is A4, 21cm
    , check.image = check.image
  )
  out <- unlist(out$each.image)
  # assumes <file name>.jpeg.txt.Area
  # make a dataframe of filename and area [m2]   
  out <- data.frame(file_name = matrix(unlist(strsplit(names(out),".", fixed = T))
                                       ,ncol = 4, byrow = T)[,1]
                    , projected_surface_area_of_element.m2 = out/(100*100)
                    , stringsAsFactors = FALSE)
  # add metadata
  attr(out,"standard.name") <- "projected_surface_area_of_element"
  attr(out,"units") <- "m2"
  return(out)
}

