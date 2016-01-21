#' Helper function to set up LeafArea run.ij
#'
#' @description  A simple wrapper passing project specific setings to \pckg{LeafArea} and ImageJ. 
#' 
#' @details If \link[http://rsb.info.nih.gov/ij/]{ImageJ} is installed in one of the default directories, you do not have to specify the path to ImageJ.
#'
#'  \code{/Applications/ImageJ/ <Mac>}
#'  
#'  \code{C:\\Program Files\\ImageJ\\ <Windows>}
#' 
#' If the OS is Linux you do need to specify the path to ImageJ. 
#' 
#' For example, \code{path = "~/ImageJ/"}
#'
#' The number of pixels per a known distance should be supplied. 
#' For an A4 sheet scanned at 150 dpi; 58.5 px/cm
#' Use the option \code{check.image=T} to view the auto-thresholding and particle analyis results in the GUI of ImageJ.
#' 
#' The amount of 'cropping' of the edges of the image is set using \code{trim.pixel}; a value of 250 is suitable for the FAST template. Probelmatic images can be manually cropped without changing the resolution, in which case trim should be adjusted accordingly.
#' 
#' Known bugs: 
#' 
#' Sometimes the analysis gives errors if repeated in same session. Solution is to save results and start a new R session before re-running. 
#' 
#' Some images cause errors. Check the resolution and dimensions of the images.
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
#' # If using Linux define the path to the ImageJ executable,
#' # if not, comment out; Leaf Area should find it.
#' # Recommend downloading and extracting the standalone version,
#' # rather than using a package manager.
#' 
#' # set path (Linux)
#' path.imagej <- "~/ImageJ"
#' 
#' # set path to test images directory
#' # A4 scans at 150 dpi, 1 cm = 58.5 px
#' path.image <- file.path(system.file("images"
#'                        , package="FASTLeafArea"),"")
#' 
#' # run analysis on images using ImageJ 
#' area <- helper.leafarea(set.directory=path.image, path.imagej=path.imagej
#'                        , trim.pixel=250, distance.pixel=58.5, known.distance=1
#'                        , check.image=F)
#' 
#' # write to file in working directory
#' write.csv(area, paste0(paste(attr(area,"standard.name")
#'          , attr(area,"units"), sep="_", ".csv"))
#'          , quote = T, na = "NA", row.names = F)
#' 
helper.leafarea <- function (set.directory, trim.pixel=0, check.image=F, distance.pixel=1, known.distance=1, path.imagej=NULL) {
  # check LeafArea package is available
  #require(LeafArea)
  # run imageJ using "standard FAST project settings"
  out <- LeafArea::run.ij(
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
