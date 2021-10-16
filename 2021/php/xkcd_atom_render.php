<?php 
    // Parse response from XKCD Atom feed and render the content in a table cerner_2tothe5th_2021 
    // test it locally php -S localhost:8000 navigate to http://localhost:8000/xkcd_atom_render.php
?>
<html>
<head>
    <style> table, th, td { border: 1px solid black; border-collapse: collapse;} </style>
</head>
<body>
<?php
    $response = file_get_contents("http://xkcd.com/atom.xml");
    $xml = simplexml_load_string($response);
?>
<table>
    <th> Title </th>
    <th> Url </th>
    <th> Image </th>
    <?php foreach($xml->entry as $entry) { ?>
        <tr>
            <td> <? echo $entry->title ?> </td>
            <td> <a href=<? echo $entry->id  ?>> URL </a> </td>
            <td> <? echo $entry->summary  ?> </td> <!-- this has the url to embed -->
        </tr>
    <? } ?>
</table>
</body>
</html>
