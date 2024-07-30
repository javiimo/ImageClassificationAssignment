{%- extends 'full.tpl' -%}

{% block header %}
    {%- if super() is not none -%}
        {{ super() }}
    {%- endif -%}
    {%- if super() is none -%}
        {# Prevents None from being rendered #}
    {%- endif -%}
    <style>
        body {
            overflow-x: hidden; /* Prevent horizontal scroll */
        }
        .toc { 
            position: fixed; 
            top: 10px; 
            right: 10px; 
            width: 250px; 
            max-height: 90%; 
            overflow-y: auto; 
            background: #f9f9f9; 
            border: 1px solid #ccc; 
            padding: 10px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }
        .toc-header {
            cursor: pointer;
            user-select: none;
        }
        .toc-content {
            display: none;
            margin-top: 10px;
        }
        .toc.expanded .toc-content {
            display: block;
        }
        .toc-toggle {
            float: right;
            transition: transform 0.3s;
        }
        .toc.expanded .toc-toggle {
            transform: rotate(180deg);
        }
        .collapsible {
            cursor: pointer;
            padding: 10px;
            width: 100%;
            border: none;
            text-align: left;
            outline: none;
            font-size: 15px;
        }
        .content {
            padding: 0 18px;
            display: none;
            overflow: hidden;
        }
        .active > .content {
            display: block;
        }
        .jp-OutputArea-output {
            overflow-x: auto;
            max-width: 100%;
        }
        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .section {
            margin-left: 20px;
        }
        #notebook-container {
            max-width: 100vw; /* Ensure content fits within viewport width */
            overflow-x: hidden; /* Prevent horizontal scroll */
        }
    </style>
{% endblock header %}

{%- block body %}
    <div class="toc">
        <div class="toc-header">
            <span>Table of Contents</span>
            <span class="toc-toggle">▼</span>
        </div>
        <div class="toc-content">
            <ul id="toc-list"></ul>
        </div>
    </div>
    <div id="notebook-container">
        {%- if super() is not none -%}
            {{ super() }}
        {%- endif -%}
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var toc = document.querySelector('.toc');
            var tocHeader = document.querySelector('.toc-header');
            var tocList = document.getElementById("toc-list");
            var cells = document.querySelectorAll('.jp-Cell');
            var sections = [];

            tocHeader.addEventListener('click', function() {
                toc.classList.toggle('expanded');
            });

            function createSection(header, level) {
                return {
                    header: header,
                    level: level,
                    content: [],
                    subsections: []
                };
            }

            function getHeaderLevel(header) {
                return parseInt(header.tagName.charAt(1));
            }

            function toggleSection(section, isCollapsing) {
                section.header.parentElement.classList.toggle("active", !isCollapsing);
                
                section.content.forEach(function(cell) {
                    cell.style.display = isCollapsing ? "none" : "";
                });
                
                section.subsections.forEach(function(subsection) {
                    subsection.header.parentElement.style.display = isCollapsing ? "none" : "";
                    if (isCollapsing) {
                        toggleSection(subsection, isCollapsing);
                    }
                });
            }

            function renderSections(sectionList, container, level = 0) {
                sectionList.forEach(function(section) {
                    var sectionDiv = document.createElement("div");
                    sectionDiv.classList.add("section");
                    sectionDiv.style.marginLeft = level * 20 + "px";
                    
                    var headerDiv = document.createElement("div");
                    headerDiv.classList.add("collapsible");
                    headerDiv.innerHTML = section.header.outerHTML;
                    sectionDiv.appendChild(headerDiv);
                    
                    headerDiv.addEventListener("click", function (e) {
                        e.stopPropagation();
                        var isCollapsing = sectionDiv.classList.contains("active");
                        toggleSection(section, isCollapsing);
                        sectionDiv.classList.toggle("active");
                    });
                    
                    var contentDiv = document.createElement("div");
                    contentDiv.classList.add("content");
                    
                    section.content.forEach(function(cell) {
                        var cellClone = cell.cloneNode(true);
                        var header = cellClone.querySelector('h1, h2, h3, h4, h5, h6');
                        if (header) {
                            header.remove();
                        }
                        contentDiv.appendChild(cellClone);
                    });
                    
                    if (section.subsections.length > 0) {
                        renderSections(section.subsections, contentDiv, level + 1);
                    }
                    
                    sectionDiv.appendChild(contentDiv);
                    container.appendChild(sectionDiv);
                });
            }

            function buildHierarchy(cells) {
                var sections = [];
                var stack = [];
                var currentSection = null;

                cells.forEach(function (cell, index) {
                    var header = cell.querySelector('h1, h2, h3, h4, h5, h6');
                    
                    if (header) {
                        var level = getHeaderLevel(header);
                        var newSection = createSection(header, level);

                        while (stack.length > 0 && stack[stack.length - 1].level >= level) {
                            stack.pop();
                        }

                        if (stack.length === 0) {
                            sections.push(newSection);
                        } else {
                            stack[stack.length - 1].subsections.push(newSection);
                        }

                        stack.push(newSection);
                        currentSection = newSection;

                        var tocItem = document.createElement("li");
                        var link = document.createElement("a");
                        link.textContent = header.textContent;
                        link.href = "#header-" + index;
                        header.id = "header-" + index;
                        tocItem.appendChild(link);
                        tocItem.style.marginLeft = (level - 1) * 10 + "px";
                        tocList.appendChild(tocItem);

                        currentSection.content.push(cell);
                    } else if (currentSection) {
                        currentSection.content.push(cell);
                    }
                });

                return sections;
            }

            var sections = buildHierarchy(cells);

            var notebookContainer = document.getElementById("notebook-container");
            notebookContainer.innerHTML = '';
            renderSections(sections, notebookContainer);

            function expandAllSections(sectionList) {
                sectionList.forEach(function(section) {
                    section.header.parentElement.classList.add("active");
                    section.header.parentElement.style.display = "";
                    section.content.forEach(function(cell) {
                        cell.style.display = "";
                    });
                    if (section.subsections.length > 0) {
                        expandAllSections(section.subsections);
                    }
                });
            }

            expandAllSections(sections);
            
            toc.classList.add('expanded');
        });
    </script>
{%- endblock body %}