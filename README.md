# HTML Conversion README

## Purpose

The `html_conversion` branch aims to transform a simplified version of a Jupyter Notebook into a static HTML file. This is accomplished using the `nbconvert` tool, which allows us to generate HTML documents from Jupyter Notebooks. The resulting HTML file features collapsible hierarchical sections and a floating collapsible index.

## Project Files

This repository contains the following key files:

- **Project_simplified.ipynb**: This is the Jupyter Notebook that contains the content to be converted into HTML. It has been simplified to include only relevant code for the methods, static plots and results.

- **nbconvert_config.py**: This configuration file customizes the behavior of `nbconvert` during the conversion process. 

- **custom_template.tpl**: This file defines a custom template for the HTML output. It allows for further customization of the appearance and structure of the generated HTML document, including the layout of collapsible sections and the floating index.

## How to Use

To convert the Jupyter Notebook into a static HTML file, follow these steps:

1. **Install Required Packages**: We used an older version of the library to avoid some dependency issues. You can do this by running:

   ```bash
   pip install nbconvert==6.4.5
   ```

2. **Modify Notebook Metadata**: Before converting, you need to modify the metadata of `Project_simplified.ipynb` to include the following necessary fields:

   ```json
    {
    "metadata": {
        "celltoolbar": "Tags",
        "kernelspec": {
        "display_name": "Python 3",
        "name": "python3"
        },
        "language_info": {
        "name": "python",
        "version": "3.10.14"
        }
    },
    "nbformat": 4,
    "nbformat_minor": 5
    }
   ```

3. **Run the Conversion Command**: Execute the following command in your terminal to convert the notebook to HTML:

   ```bash
   jupyter nbconvert --config nbconvert_config.py Project_simplified.ipynb
   ```

After running this command, you will find the generated HTML file in the same directory as the original notebook, ready for viewing and sharing. 
> **Note:** If a "None" string appears at the top of the document, you can remove it manually from the .html file by simply deleting it at the beginning.