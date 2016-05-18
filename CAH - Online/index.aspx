<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    protected void SelectButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/waitingRoom.aspx");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!FunctionsDB.ExistCookies())
        {
            SelectButton.Enabled = false;
        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
</asp:Content>
