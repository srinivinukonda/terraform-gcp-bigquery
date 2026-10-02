module "dataset" {
  source = "../.."

  project_id = "my-project"
  dataset_id = "example"
  location   = "europe-west2"
  labels     = { env = "dev" }

  # kms_key_name = "projects/my-project/locations/europe-west2/keyRings/bq/cryptoKeys/bq"

  iam_members = {
    "roles/bigquery.dataViewer" = ["group:analysts@example.com"]
    "roles/bigquery.dataEditor" = ["serviceAccount:etl@my-project.iam.gserviceaccount.com"]
  }
}
