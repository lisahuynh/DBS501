<html lang="en">

<head>
    <title>COMP214-TEAM9</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="styles.css">
</head>

<body>
    <header>
        

        <h2 style="font-family: Brush Script MT">
            Brewbean’s
            Coffee Shop</h2>

    </header>

    <section>
        <nav>
            <ul>
            <li><a href="homepage.php">Homepage</a></li>
                <li><a href="changeProductDesc.php">Change Product Description(Task1)</a></li>
                <li><a href="taxcal.php">Calculate Tax(Task3)</a></li>
                <li><a href="updatedis.php">Update Order Status(Task4)</a></li>
                <li><a href="additemtobasketdis.php">Add Items to Basket(Task5)</a></li>
                <li><a href="identifysaleproductsdis.php">Identify Sale Products(Task6)</a></li>
                <li><a href="report1.php">Check Stock Status(Report1)</a></li>
                <li><a href="totaldis.php">Check Total Cost(Report2)</a></li>
            </ul>
        </nav>

        <article>
            <h3>Add New Product</h3>    
<p>

<?php
	$idProduct = $_POST['idProduct'];
	$ProductName = $_POST['ProductName'];
    $Description = $_POST['Description'];
	$ProductImage = $_POST['ProductImage'];
    $Price = $_POST['Price'];
	$Active = $_POST['Active'];
	
	$conn = oci_connect("system", "manager", "//localhost/XE");
	
	
	$sql = "call PROD_ADD_SP(:idProduct, :ProductName, :Description,:ProductImage,:Price,:Active)";

	$stmt = oci_parse($conn, $sql); 
	oci_bind_by_name($stmt,':idProduct',$idProduct);           
	oci_bind_by_name($stmt,':ProductName',$ProductName);
	oci_bind_by_name($stmt,':Description',$Description);
	oci_bind_by_name($stmt,':ProductImage',$ProductImage);
	oci_bind_by_name($stmt,':Price',$Price);
	oci_bind_by_name($stmt,':Active',$Active);
	
    oci_execute($stmt);

		print "Produce has been added.";
		print '<br/>';
		print "The new Product Id is: $idProduct, new Product Name is: $ProductName, 
		new Description is: $Description, new Product Image Name is: $ProductImage, 
		new Price is: $Price, new Active Status is: $Active";
		oci_close($conn);


		$conndisplay = oci_connect("system", "manager", "//localhost/XE");

		
		$querydisplay = 'select idproduct, productname, description,productimage, price, active from bb_product ORDER BY idProduct';
$stiddisplay = oci_parse($conndisplay, $querydisplay);
$rdisplay = oci_execute($stiddisplay);

// Fetch the results in an associative array
print '<table border="1">';
print "<tr>
<th>Product ID</th>
<th>Product Name</th>
<th>Description</th>
<th>Oroduct Image Name</th>
<th>Price</th>
<th>Active Status</th>
</tr>";

while ($row = oci_fetch_array($stiddisplay, OCI_RETURN_NULLS+OCI_ASSOC)) {
   print '<tr>';
   foreach ($row as $item) {
      print '<td>'.($item?htmlentities($item):' ').'</td>';
   }
   print '</tr>';
}
print '</table>';

// Close the Oracle connection
oci_close($conndisplay);
	
?>
<br>
<a href="addproductdis.php">Back to submition page</a>
</p>
        </article>
    </section>

    <footer>
        <p>Copyright © 2022 COMP214-TEAM9. All rights reserved.</p>
    </footer>

</body>

</html>