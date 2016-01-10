<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">
    
    String email;

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
<script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
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
                                <a href="index.aspx" class="nav-text">Home</a>
                            </li>
                            <li>
                                <a href="rules.aspx" class="nav-text nav-active">Rules</a>
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
            <div>
                <div class="card-panel teal-panel">
                    <h1 class="h1-text">Le regole del gioco<br />
                        <br />
                    </h1>
                    <p class="paragraph p1">
                        Le regole basilari del gioco sono:<br />
                        <br />
                        <ul>
                            <li class="color-number-list li-list">1.
                                <i class="paragraph p2">Si distribuiscono 10 carte Risposta a ciascun giocatore.<br />
                                    <br />
                                </i>
                            </li>
                            <li class="color-number-list li-list">2.
                                <i class="paragraph p2">Si sceglie chi leggerà la domanda al primo turno (master). Il master sceglie una carta Domanda (carta nera) e la legge ad alta voce.<br />
                                    <br />
                                </i>
                            </li>
                            <li class="color-number-list li-list">3.
                                <i class="paragraph p2">I giocatori scelgono in un periodo limitato di tempo la carta Risposta (carta bianca) da dare al master, cercando di scegliere la più divertente tra quelle che hanno.<br />
                                    <br />
                                </i>
                            </li>
                            <li class="color-number-list li-list">4.
                                <i class="paragraph p2">Il master mischia le carte senza vederle e legge una ad una le risposte ad alta voce.<br />
                                    <br />
                                </i>
                            </li>
                            <li class="color-number-list li-list">5.
                                <i class="paragraph p2">Il master sceglie la carta Risposta che più gli è piaciuta e la dichiara. In quel momento il giocatore che ha giocato la carta si rivela e guadagna un punto vittoria.<br />
                                    <br />
                                </i>
                            </li>
                            <li class="color-number-list li-list">6.
                                <i class="paragraph p2">Tutti i giocatori pescano le carte Risposta per tornare al numero iniziale di 10.<br />
                                    <br />
                                </i>
                            </li>
                            <li class="color-number-list li-list">7.
                                <i class="paragraph p2">Il giocatore che ha ottenuto il punto vittoria sarà il master per il turno successivo.<br />
                                    <br />
                                </i>
                            </li>
                            <li class="color-number-list li-list">8.
                                <i class="paragraph p2">Vince il giocatore con più punti vittoria.<br />
                                    <br />
                                </i>
                            </li>
                        </ul>
                        <p class="paragraph p1">
                            <br />
                            Esistono ovviamente molte variabili al gioco. Gli stessi creatori invogliano lo sviluppo di nuove forme di gioco e di assegnazione dei punti.<br />
                            Si può decidere di inserire un master fisso, o di premiare maggiormente il cinismo o il sadismo delle risposte. 
                        </p>
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
