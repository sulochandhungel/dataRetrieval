#' Raw Data Import for Instantaneous USGS NWIS Data
#'
#' Imports data from NWIS web service. This function gets the data from here: \url{http://waterservices.usgs.gov/}
#' A list of parameter codes can be found here: \url{http://nwis.waterdata.usgs.gov/nwis/pmcodes/}
#' A list of statistic codes can be found here: \url{http://nwis.waterdata.usgs.gov/nwis/help/?read_file=stat&format=table}
#'
#' @param siteNumber string USGS site number.  This is usually an 8 digit number
#' @param parameterCd string USGS parameter code.  This is usually an 5 digit number.
#' @param startDate string starting date for data retrieval in the form YYYY-MM-DD.
#' @param endDate string ending date for data retrieval in the form YYYY-MM-DD.
#' @param interactive logical Option for interactive mode.  If true, there is user interaction for error handling and data checks.
#' @param format string, can be "tsv" or "xml", and is only applicable for daily and unit value requests.  "tsv" returns results faster, but there is a possiblitiy that an incomplete file is returned without warning. XML is slower, 
#' but will offer a warning if the file was incomplete (for example, if there was a momentary problem with the internet connection). It is possible to safely use the "tsv" option, 
#' but the user must carefully check the results to see if the data returns matches what is expected. The default is therefore "xml". 
#' @keywords data import USGS web service
#' @return data dataframe with agency, site, dateTime, time zone, value, and code columns
#' @export
#' @examples
#' siteNumber <- '05114000'
#' parameterCd <- '00060'
#' startDate <- as.character(Sys.Date())
#' endDate <- as.character(Sys.Date())
#' # These examples require an internet connection to run
#' rawData <- retrieveNWISunitData(siteNumber,parameterCd,startDate,endDate)
#' rawData2 <- retrieveNWISunitData(siteNumber,parameterCd,startDate,endDate,"tsv")
retrieveNWISunitData <- function (siteNumber,parameterCd,startDate,endDate,format="xml",interactive=TRUE){  
  
  url <- constructNWISURL(siteNumber,parameterCd,startDate,endDate,"uv",format=format,interactive=interactive)
  if (format == "xml") {
    data <- getWaterML1Data(url)
  } else {
    data <- getRDB1Data(url,asDateTime=TRUE)
  }

  return (data)
}
