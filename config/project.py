import config.helpers

project_github_username = "veltzer"
project_name = "bashy"
github_repo_name = project_name
project_website = f"https://{project_github_username}.github.io/{project_name}"
project_website_source = f"https://github.com/{project_github_username}/{project_name}"
project_website_git = f"git://github.com/{project_github_username}/{project_name}.git"
project_website_download_ppa = "https://launchpanet/~mark-veltzer/+archive/ubuntu/ppa"
project_website_download_src = project_website_source
# noinspection SpellCheckingInspection
project_paypal_donate_button_id = "ASPRXR59H2NTQ"
project_google_analytics_tracking_id = "UA-56436979-1"
project_short_description = "bashy handles bash configuration for you"
project_long_description = project_short_description
# keywords to put on html pages or for search, dont put the name of the project or my details
# as they will be added automatically...
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

codacy_id = None
project_google_analytics_tracking_id = None
project_paypal_donate_button_id = None

project_copyright_years = config.helpers.get_copyright_years(project_year_started)
project_google_analytics_snipplet = config.helpers.get_google_analytics(project_google_analytics_tracking_id)
project_paypal_donate_button_snipplet = config.helpers.get_paypal(project_paypal_donate_button_id)
