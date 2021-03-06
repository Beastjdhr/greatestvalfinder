# Adding Visual and Interactive Features to Phylogenetic Trees
  This tutorial was designed for Ubuntu users and it assumes you already have a phylogenetic tree stored in the Newick format.
## Save your Tree as XML/PhyloXML (in case it is not in any of these formats)  

In order to make your tree a little more appealing to the eye, it must be in an XML format. To change its format from Newick,     go to the following website:
https://phyd3.bits.vib.be/view.php?id=71d752e8b21452c2dcd8267f94a58bb7.xml&f=xml
  		  Once you have opened your tree, choose the option: "Download as XML". Now you have an XML file of your tree.
## Open your XML tree using HTML
 
### Download the necessary libraries
   The following libraries will be used to make your tree look better:
      
Raphael (js library) (https://raw.githubusercontent.com/DmitryBaranovskiy/raphael/master/raphael.min.js)
      
jsPhyloSVG (https://github.com/guyleonard/jsPhyloSVG/blob/master/jsphylosvg-min.js)
      
jQuery 1.4.2 (http://code.jquery.com/jquery-1.4.2.min.js)
         
Create a text file with the following code:

     <html>
         <head>
    	         <script type="text/javascript" src="/your/path/to/jquery/library" ></script> 
	             <script type="text/javascript" src="/your/path/to/raphael/library" ></script> 
               <script type="text/javascript" src="/your/path/to//jsphylosvg/library"></script> 
	
         	     <script type="text/javascript">
	               $(document).ready(function(){
		             $.get("/your/xml/file/directory/xmlfile.xml", function(data) {
			                var dataObject = {
				              xml: data,
				              fileSource: true
			                 };		
			              phylocanvas = new Smits.PhyloCanvas(
				              dataObject,
				             'svgCanvas', 
			              	800, 800,
				             'circular'
		                   	 );
	                     	 });
                       	});
	          </script>

         </head>
           <body>
	               <div id="svgCanvas"> </div>
          </body>
      </html>
        

If your tree is rectangular, change "circular" to "rectangular" in the line below "800,800".
   
   Now that you have your XML working, you can start adding interactive features to your tree by modifying its XML script.
   
If you want to have some XML tags generated for your XML tree, you can use the program I created, **tag_generator.pl**, which can be found in my repo. The only thing you need besides the program is your organism data written in a format like the one in **corecyanos**, another file you can find in my repo. 

Once you have your data written in the same structure as that of **corecyanos**, go to your terminal and type:

         perl tag_generator.pl name_of_input_file name_of_output_file
         
And there you have it! A set of tags ready to be used in your XML phylogenetic tree. To lear more about jsPhylosSVG's capability, click on the following link: http://www.jsphylosvg.com/documentation.php
