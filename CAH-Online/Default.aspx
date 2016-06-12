<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link href="js/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="js/bootstrap.css.map" type="text/plain" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="css/Style2.css" />
    <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="css/materialize.min.css" media="screen,projection" />
    <title></title>
</head>
<body style="background-color:#000">
    <form id="form1" runat="server">
        <!-- Dropdown Structure -->
        <ul id="dropdown1" class="dropdown-content">
            <li><a href="profile.aspx" class="nav-text">Profile</a></li>
            <li><a href="settings.aspx" class="nav-text">Settings</a></li>
            <li class="divider"></li>
            <li><a href="index.aspx" class="nav-text">Logout</a></li>
        </ul>
        <nav>
            <div class="nav-wrapper">
                <a href="index.aspx" class="brand-logo center">
                    <img src="img/logo2.png" alt="CAH - Online" />
                </a>
                <ul class="right hide-on-med-and-down">
                    <li>
                        <a runat="server" href="index.aspx" class="nav-text">Home</a>
                    </li>
                    <li>
                        <a href="rules.aspx" class="nav-text">Rules</a>
                    </li>
                    <li>
                        <a class="dropdown-button nav-text" href="index.aspx" data-activates="dropdown1">
                            <asp:Label ID="Label1" runat="server" CssClass="label-form">PROVA</asp:Label>
                            <i class="material-icons right">arrow_drop_down</i>
                        </a>
                    </li>
                </ul>
            </div>
            <div class="nav-wrapper">
                <a href="index.aspx" class="brand-logo center">
                    <img src="img/logo2.png" alt="CAH - Online" />
                </a>
                <ul class="right hide-on-med-and-down">
                    <li>
                        <a runat="server" href="index.aspx" class="nav-text">Home</a>
                    </li>
                    <li>
                        <a href="rules.aspx" class="nav-text">Rules</a>
                    </li>
                    <li>
                       <a href="login.aspx" class="nav-text">Login</a>
                    </li>
                    <li>
                       <a href="register.aspx" class="nav-text">Register</a>
                    </li>
                </ul>
            </div>
        </nav>
    </form>
     <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
      <script type="text/javascript" src="js/materialize.min.js"></script>
</body>
</html>