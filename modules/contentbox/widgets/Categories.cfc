﻿/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A cool basic widget that shows our blog categories
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	Categories function init(){
		// Widget Properties
		setName( "Categories" );
		setDescription( "A cool widget that renders your blog categories summary." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "tags" );
		setCategory( "Blog" );
		return this;
	}

	/**
	 * Show the blog categories
	 *
	 * @dropdown Display as a dropdown or a list, default is list
	 * @showPostCount Show post counts or not, default is true
	 * @title The title to show before the dropdown or list, defaults to H2
	 * @titleLevel The H{level} to use, by default we use H2
	 */
	any function renderIt(
		boolean dropdown      = false,
		boolean showPostCount = true,
		string title          = "",
		string titleLevel     = "2"
	){
		var categories = variables.categoryService.list(
			criteria : { "site" : getSite() },
			sortOrder= "category",
			asQuery  = false
		);
		var rString = "";

		// generate recent comments
		saveContent variable="rString" {
			// title
			if ( len( arguments.title ) ) {
				writeOutput(
					"<h#arguments.titlelevel#>#arguments.title#</h#arguments.titlelevel#>
"
				);
			}
			// Build Type
			if ( arguments.dropdown ) {
				writeOutput( buildDropDown( categories, arguments.showPostCount ) );
			} else {
				writeOutput( buildList( categories, arguments.showPostCount ) );
			}
		}

		return rString;
	}

	private function buildDropDown( categories, showPostCount ){
		var rString         = "";
		// generate recent comments
		saveContent variable="rString" {
			writeOutput(
				"<select
	name=""categories"" id=""categories"" onchange=""window.location=this.value""
	)

>
	<option value=""##"">Select Category</option>
	"
			);
			// iterate and create
			for ( var x = 1; x lte arrayLen( arguments.categories ); x++ ) {
				if ( arguments.categories[ x ].getNumberOfEntries() gt 0 ) {
					writeOutput(
						"<option value=""#cb.linkCategory( arguments.categories[ x ] )#"">#arguments.categories[ x ].getCategory()#"
					);

					if ( arguments.showPostCount ) {
						writeOutput( " (#arguments.categories[ x ].getNumberOfEntries()#)" );
					}
					writeOutput(
						"</option>
	"
					);
				}
			}
			// close ul
			writeOutput(
				"
</select>
"
			);
		}
		return rString;
	}

	private function buildList( categories, showPostCount ){
		var rString         = "";
		// generate recent comments
		saveContent variable="rString" {
			writeOutput(
				"<ul id=""categories"">
	"
			);
			for ( var x = 1; x lte arrayLen( arguments.categories ); x++ ) {
				if ( arguments.categories[ x ].getNumberOfEntries() gt 0 ) {
					writeOutput(
						"<li class=""categories"">
		<a href=""#cb.linkCategory( arguments.categories[ x ] )#"">#arguments.categories[ x ].getCategory()#"
					);
					if ( arguments.showPostCount ) {
						writeOutput( " (#arguments.categories[ x ].getNumberOfEntries()#)" );
					}
					writeOutput(
						"</a>
	</li>
	"
					);
				}
			}
			// close ul
			writeOutput(
				"
</ul>
"
			);
		}
		return rString;
	}

}
