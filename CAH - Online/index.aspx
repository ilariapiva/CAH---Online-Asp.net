<%@ Page Language="C#" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    protected void SelectButton_Click(object sender, EventArgs e)
    {
        string script = "alert(\"Per iniziare a giocare devi prima effetturare il login!\");";
        ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
      
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap.css.map" rel="stylesheet" />
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
                        <a href="indexaspx">
                            <img src="img/logo2.png" alt="CAH - Online" />
                        </a>
                    </div>
                    <div class="collapse navbar-collapse">
                        <ul class="nav navbar-nav navbar-right">
                            <li>
                                <a href="index.aspx" class="nav-text nav-active">Home</a>
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
                        <asp:LinkButton ID="SelectButton" runat="server" CssClass="btn btn-start-play text-btn-play" OnClick="SelectButton_Click"><i class="icon-ok icon-white"><img class="img-play" src="img/play.png" alt="play"/></i>&nbsp;Start a new game</asp:LinkButton>
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
