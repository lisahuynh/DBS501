
<html lang="en">

<head>
    <title>COMP214-TEAM9</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="styles.css">
</head>

<body>
    <header>
        <!--<img src="logo.jpg" alt="logo" width="200" height="200">-->

        <h2 style="font-family: Brush Script MT">
            Brewbean’s
            Coffee Shop</h2>

    </header>

    <section>
        <nav>
            <ul>
            <li><a href="homepage.php">Homepage</a></li>
                <li><a href="changeProductDesc.php">Change Product Description(Task1)</a></li>
                <li><a href="addproductdis.php">Add New Product(Task2)</a></li>
                <li><a href="taxcal.php">Calculate Tax(Task3)</a></li>
                <li><a href="updatedis.php">Update Order Status(Task4)</a></li>
                <li><a href="additemtobasketdis.php">Add Items to Basket(Task5)</a></li>
                <li><a href="identifysaleproductsdis.php">Identify Sale Products(Task6)</a></li>
                <li><a href="report1.php">Check Stock Status(Report1)</a></li>
                <li><a href="totaldis.php">Check Total Cost(Report2)</a></li>  
            </ul>
        </nav>

        <article>
    <h3>Search Product</h3>

        <P>
        <?php
$ProductName = $_POST['ProductName'];

$connsearch = oci_connect("system", "manager", "//localhost/XE");
$querysearch = "select idproduct, productname, description,productimage, price, active from bb_product where upper(ProductName) like upper('%$ProductName%')";
$stidsearch = oci_parse($connsearch, $querysearch);
$rsearch = oci_execute($stidsearch);
// Fetch the results in an associative array
print 'The search result is as follows';
print '<table border="1">';
print "<tr>
<th>Product ID</th>
<th>Product Name</th>
<th>Description</th>
<th>Oroduct Image Name</th>
<th>Price</th>
<th>Active Status</th>
</tr>";

while ($row = oci_fetch_array($stidsearch, OCI_RETURN_NULLS+OCI_ASSOC)) {
   print '<tr>';
   foreach ($row as $item) {
      print '<td>'.($item?htmlentities($item):' ').'</td>';
   }
   print '</tr>';
}
print '</table>';

// Close the Oracle connection
oci_close($connsearch);
	
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