{
    "terraform": {
        "backend": {
            "s3": {
                "bucket": "tfstate-dockerlab-dev", 
                "key": "tfStateFile-dockerlab-dev", 
                "region": "us-west-2"
            }
        }
    }
}