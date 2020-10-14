variable sops_file_path {
    type = string
}

variable chart_version {
    type = string
}

variable environment {
    type = string
}

variable extra_answers {
    type = map(string)
    default = {}
}