
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
                <li><a href="updatedis.php">Update Order Status(Task4)</a></li>
                <li><a href="additemtobasketdis.php">Add Items to Basket(Task5)</a></li>
                <li><a href="identifysaleproductsdis.php">Identify Sale Products(Task6)</a></li>
                <li><a href="report1.php">Check Stock Status(Report1)</a></li>
                <li><a href="totaldis.php">Check Total Cost(Report2)</a></li>  
            </ul>
        </nav>

        <article>
            <h3>Calculate the tax</h3>
            <form action="taxprocess.php" method="POST">
        <p>
			<label>State:</label>
			<input type="text" name="state"/>
		</p>
		<p>
			<label>Subtotal amount:</label>
			<input type="text" name="subtot"/>
		</p>
    
		<p>
			<input type="submit" value="Submit" />
		</p>
	</form>

    
</p>
        </article>
    </section>

    <footer>
        <p>Copyright © 2022 COMP214-TEAM9. All rights reserved.</p>
    </footer>

</body>

</html>