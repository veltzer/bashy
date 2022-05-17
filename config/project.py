import pydmt.helpers.signature

project_github_username = "veltzer"
project_name = "bashy"
github_repo_name = project_name
project_website = f"https://{project_github_username}.github.io/{project_name}"
project_website_source = f"https://github.com/{project_github_username}/{project_name}"
project_website_git = f"git://github.com/{project_github_username}/{project_name}.git"
project_website_download_ppa = "https://launchpanet/~mark-veltzer/+archive/ubuntu/ppa"
project_website_download_src = project_website_source
project_short_description = "bashy handles bash configuration for you"
project_long_description = project_short_description
project_keywords = [
    "bashy",
    "bash",
    "completions",
    "powerline",
    "powerline-shell",
    "bash-it",
]
project_license = "MIT"
project_year_started = 2017
project_description = project_short_description
project_platforms = [
    "bash",
]
project_classifiers = [
]

project_data_files = []

project_copyright_years_long = pydmt.helpers.signature.get_copyright_years_long(project_year_started)
