
library(tidyverse)
library(humanize)

space_info <- aws.s3::get_bucket(
  "gis-hub",
  region = "sfo3",
  check_region = FALSE,
  key = Sys.getenv("DO_SPACES_ACCESS_KEY"),
  secret = Sys.getenv("DO_SPACES_SECRET_KEY"),
  base_url = "digitaloceanspaces.com")


space_info_df <- aws.s3::get_bucket_df(
  "gis-hub",
  region = "sfo3",
  check_region = FALSE,
  key = Sys.getenv("DO_SPACES_ACCESS_KEY"),
  secret = Sys.getenv("DO_SPACES_SECRET_KEY"),
  base_url = "digitaloceanspaces.com"
) %>%
  rowwise() %>%
  mutate(
    Size=humanize::natural_size(as.numeric(Size)),
    url = paste0("https://gis-hub.sfo3.cdn.digitaloceanspaces.com/", Key),
    link = paste0('<a href="', url, '" target="_blank">Download</a>')
    ) %>%
ungroup() %>%
 select(File_Name=Key,
        LastModified,
        Size,
        link
        ) %>%
  filter(!str_detect(File_Name,"/$"))



# Create the datatable
gis_hub_datatable <- DT::datatable(space_info_df, escape = FALSE,
              rownames = FALSE, options = list(pageLength = 25))

