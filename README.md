[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.5.x&color=orange)

# The Tuva Project Demo

## 🧰 What does this project do?

This demo provides a quick and easy way to run the Tuva Project 
Package in a dbt project with synthetic data for 1k patients loaded as dbt seeds.

To set up the Tuva Project with your own claims data or to better understand what the Tuva Project does, please review the ReadMe in [The Tuva Project](https://github.com/tuva-health/the_tuva_project) package for a detailed walkthrough and setup.

For information on the data models check out our [Docs](https://thetuvaproject.com/).

## 🔌 Database Support

- BigQuery
- Databricks (community supported)
- DuckDB (community supported)
- Redshift
- Snowflake
- Microsoft Fabric

## ✅ How to get started

### Pre-requisites
1. You have [uv](https://docs.astral.sh/uv/getting-started/) installed (a fast Python package manager). Installation is simple and OS-agnostic:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
   Or on Windows:
   ```powershell
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
   ```
2. You have [dbt](https://www.getdbt.com/) configured and connected to your data warehouse (uv will handle the dbt installation).
3. You have created a database for the output of this project to be written in your data warehouse.

### Getting Started
Complete the following steps to configure the project to run in your environment.

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repo to your local machine or environment.
2. In the project directory, install Python dependencies and set up the virtual environment:
   ```bash
   uv sync
   ```
3. Activate the virtual environment:
   ```bash
   source .venv/bin/activate  # On macOS/Linux
   # or on Windows:
   .venv\Scripts\activate
   ```
4. Update the `dbt_project.yml` file:
   - Add the dbt profile connected to your data warehouse.
5. Run `dbt deps` to install the Tuva Project package.
6. Run `dbt build` to run the entire project with the built-in sample data.

### Using uv commands
You can also run dbt commands directly with `uv run` without activating the virtual environment:
```bash
uv run dbt deps
uv run dbt build
```

## 🙋🏻‍♀️ **How is this project maintained and can I contribute?**

### Project Maintenance

The Tuva Project team maintaining this project **only** maintains the latest version of the project. 
We highly recommend you stay consistent with the latest version.

### Contributions

Have an opinion on the mappings? Notice any bugs when installing and running the project?
If so, we highly encourage and welcome feedback!  While we work on a formal process in Github, we can be easily reached on our Slack community.

## 🤝 Community

Join our growing community of healthcare data practitioners on [Slack](https://join.slack.com/t/thetuvaproject/shared_invite/zt-16iz61187-G522Mc2WGA2mHF57e0il0Q)!
