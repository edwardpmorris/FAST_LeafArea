#' Helper function to run LeafArea run.ij
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
#'
#' @return A dataframe with ?filename? and calculated area (in the specified units)
#' @export
#'
#' @examples
#' out1 <- helper.leafarea(set.directory="~/Dropbox/LeafArea/Archive/Images_ok/", trim.pixel=250)
#' 
helper.leafarea <- function (set.directory, trim.pixel, check.image=F, distance.pixel=1, known.distance=1) {
  # run with displaying analyzed images. Press any keys when you finish cheking analyzed images."
  require(LeafArea)
  out <- run.ij(
     set.directory = set.directory
    , trim.pixel=trim.pixel
    , low.size = 10
    , log=TRUE
    , check.image=check.image
    , distance.pixel=distance.pixel
    , known.distance=known.distance
  )
  
  return(out)
}
