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
                <li><a href="addproductdis.php">Add New Product(Task2)</a></li>
                <li><a href="taxcal.php">Calculate Tax(Task3)</a></li>
                <li><a href="additemtobasketdis.php">Add Items to Basket(Task5)</a></li>
                <li><a href="identifysaleproductsdis.php">Identify Sale Products(Task6)</a></li>
                <li><a href="report1.php">Check Stock Status(Report1)</a></li>
                <li><a href="totaldis.php">Check Total Cost(Report2)</a></li>
            </ul>
        </nav>

        <article>
            <h3>Update Order Status</h3>    
<p>

<?php

	$idBasket = $_POST['idBasket'];
	$dtStage = $_POST['dtStage'];
    $shipper = $_POST['shipper'];
	$ShippingNum = $_POST['ShippingNum'];
	
	$conn = oci_connect("system", "manager", "//localhost/XE");

	
	$sql = "BEGIN STATUS_SHIP_SP(:idBasket, :dtStage, :shipper, :ShippingNum); END;";

	$stmt = oci_parse($conn, $sql); 
	          
	oci_bind_by_name($stmt,':idBasket',$idBasket);
	oci_bind_by_name($stmt,':dtStage',$dtStage);
	oci_bind_by_name($stmt,':shipper',$shipper);
	oci_bind_by_name($stmt,':ShippingNum',$ShippingNum);
	
    oci_execute($stmt);

    print "The new order status has been updated.";
    print '<br/>';
    print "Basket #: $idBasket\n
    Date shipped: $dtStage\n
    Shipper: $shipper\n
    Tracking #: $ShippingNum";
	
    oci_close($conn);
	
?>
<br>
<a href="updatedis.php">Back to submition page</a>
</p>
        </article>
    </section>

    <footer>
        <p>Copyright © 2022 COMP214-TEAM9. All rights reserved.</p>
    </footer>

</body>

</html>