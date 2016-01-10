<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    String email;

    //Memorizzo tramite i cookies l'email e tramite l'email faccio un controllo nel db e ricavo lo username
    
    protected void Page_Load(object sender, EventArgs e)
    {
        FunctionsDB.OpenConnectionDB();
        email = Request.Cookies["userEmail"].Value;

        if (Request.Cookies["userEmail"] != null)
        {
            email = Server.HtmlEncode(Request.Cookies["userEmail"].Value);
        }
        
        String strsql = "SELECT username FROM tblAccount WHERE email = '" + email + "' ";
        List<string> resultUser = FunctionsDB.ReadUsernameDB(strsql);

        lblUser.Text = resultUser[0];
    }
</script>
<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap.css.map" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/Style.css" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    <title>CAH - Online</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <nav class="navbar navbar-inverse nav-color navbar-width" role="navigation">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a href="indexaspx">
                            <img src="img/logo2.png" alt="CAH - Online" /></a>
                    </div>
                    <div class="collapse navbar-collapse">
                        <ul class="nav navbar-nav navbar-right">
                            <li>
                                <a href="index.aspx" class="nav-text nav-active">Home</a>
                            </li>
                            <li>
                                <a href="rules.aspx" class="nav-text">Rules</a>
                            </li>
                            <li class="dropdown">
                               <a href="#" class="dropdown-toggle nav-text" data-toggle="dropdown">
                                    <asp:Label class="control-label label-form" ID="lblUser" runat="server"></asp:Label>
                                &nbsp;<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a href="profile.aspx" class="nav-text">Profile</a>
                                    </li>
                                    <li>
                                        <a href="settings.aspx" class="nav-text nav-border">Settings</a>
                                    </li>
                                    <li>
                                        <a href="login.aspx" class="nav-text">Logout</a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
            <div class="row">
                <div class="col-md-6">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card-panel teal-panel">
                                <h1 class="h1-text">Descrizione del gioco<br />
                                    <br />
                                </h1>
                                <p class="paragraph p3">CAH – Online si riferisce a <a class="link" href="https://cardsagainsthumanity.com">Cards Against Humanity</a>, un gioco da tavolo americano, basato sul sarcasmo e sull'ironia dei suoi stessi giocatori. Il gioco sfrutta la licenza Creative Commons ed è attualmente disponibile con licenza Free Download, che ne permette il download e la copia in forma completamente gratuita. Il suo titolo è un riferimento alla frase Crimini contro l'umanità, in allusione al suo contenuto politicamente scorretto.</p>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card-panel teal-panel">
                                <h1 class="h1-text">La nascita del gioco<br />
                                    <br />
                                </h1>
                                <p class="paragraph p3">Il gioco è stato creato da un gruppo di studenti della scuola superiore di Highland Park, nell'Illinois, per celebrare la festa di capodanno e fu finanziato attraverso il sito web <a class="link" href="https://www.kickstarter.com">Kickstarter</a>, superando l'obiettivo prefissato di quasi il 300%. Ben Hantoot, uno dei creatori, dichiarò che lo sviluppo del gioco era in larga parte dovuto a: "8 di noi che fummo il nucleo di creatori e scrittori, 5 o 6 collaboratori occasionali e decine di amici e conoscenti che hanno giocato al gioco".</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="row">
                        <button class="btn btn-start-play text-btn-play" type="submit" name="action">
                            Start a new game<br />
                            <i class="material-icons right icon-btn-play">play_arrow</i>
                        </button>
                    </div>
                </div>
            </div>
            <footer class="footer">
                <div class="black-text p-footer">
                    <p class="left-footer">Copyright &copy; Ilaria Piva</p>
                    <p class="right-footer">CAH - Online 2015/2016</p>
                </div>
            </footer>
        </div>
    </form>
</body>
</html>
