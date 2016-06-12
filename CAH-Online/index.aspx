<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    Room room = new Room();
    int indexRoom = 0;
    int totalSeconds = 0;
    int seconds = 0;
    int minutes = 0;
    string time = "";
    List<Cards> whiteCards = FunctionsDB.CardsWhite();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Session["time1"] = 50;
            GenerateCardsWhite();
        }

        if (!FunctionsDB.ExistCookies())
        {
            SelectButton.Enabled = false;
        }
        else
        {
            if (room.ExistUserInRoom(Master.resultUser))
            {
                indexRoom = room.ReturnKeyRoomUser(Master.resultUser);

                if (room.CheckDeleteCardsUser(Master.resultUser))
                {
                    room.DeleteCardsUser(Master.resultUser);
                }
                if (room.CheckDeleteUser(indexRoom, Master.resultUser))
                {
                    room.DeleteUser(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckUserInGame(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteUserInGame(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckCardsUser(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckDeleteCardsWhite(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteCardsWhite(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckDeleteCardsBlack(indexRoom))
                {
                    FunctionsDB.DeleteCardsBlack(indexRoom);
                }
                if (FunctionsDB.CheckDeleteMaster(indexRoom))
                {
                    FunctionsDB.DeleteMaster(indexRoom);
                }
            }
        }
    }

    protected int RandomCard(List<Cards> listCards)
    {
        Random random = new Random();
        int r = random.Next(listCards.Count);
        return r;
    }

    protected void GenerateCardsWhite()
    {
        int cardCount = RandomCard(whiteCards);
        Cards cardWhite = new Cards();
        cardWhite = whiteCards[cardCount];

        lblCardWhite.Attributes.Add("value", cardWhite.idCards.ToString());
        lblCardWhite.Text = cardWhite.Text;
    }


    protected void Timer1_Tick(object sender, EventArgs e)
    {
        Session["time1"] = Convert.ToInt16(Session["time1"]) - 1;
        totalSeconds = Convert.ToInt16(Session["time1"]);
        seconds = totalSeconds % 60;
        minutes = totalSeconds / 60;
        time = minutes + ":" + seconds;
        GenerateCardsWhite();
    }

    protected void SelectButton_Click(object sender, EventArgs e)
    {
        if (room.ExistUserInRoom(Master.resultUser))
        {
            indexRoom = room.ReturnKeyRoomUser(Master.resultUser);

            if (room.CheckDeleteCardsUser(Master.resultUser))
            {
                room.DeleteCardsUser(Master.resultUser);
            }
            if (room.CheckDeleteUser(indexRoom, Master.resultUser))
            {
                room.DeleteUser(indexRoom, Master.resultUser);
            }
            if (FunctionsDB.CheckUserInGame(indexRoom, Master.resultUser))
            {
                FunctionsDB.DeleteUserInGame(indexRoom, Master.resultUser);
            }
            if (FunctionsDB.CheckCardsUser(indexRoom, Master.resultUser))
            {
                FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
            }
            if (FunctionsDB.CheckDeleteCardsWhite(indexRoom, Master.resultUser))
            {
                FunctionsDB.DeleteCardsWhite(indexRoom, Master.resultUser);
            }
            if (FunctionsDB.CheckDeleteCardsBlack(indexRoom))
            {
                FunctionsDB.DeleteCardsBlack(indexRoom);
            }
            if (FunctionsDB.CheckDeleteMaster(indexRoom))
            {
                FunctionsDB.DeleteMaster(indexRoom);
            }
        }
        Response.Redirect("~/waitingRoom.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" type="text/css" href="css/Cards.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    </div>
    <asp:UpdatePanel ID="Pannello" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Timer ID="Timer1" runat="server" Interval="3000" OnTick="Timer1_Tick" />
            <div class="row">
                <div class="col-md-6">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card-panel-text">
                                <%--<h1 class="h1-text">Descrizione del gioco<br />
                            <br />
                        </h1>--%>
                                <h1 class="h1-text">Game Description<br />
                                    <br />
                                </h1>
                                <%--<p class="paragraph p3">
                            CAH – Online si riferisce a 
                            <a class="link" href="https://cardsagainsthumanity.com">Cards Against Humanity</a>, 
                            un gioco da tavolo americano, basato sul sarcasmo e sull'ironia dei suoi stessi giocatori. Il gioco sfrutta la licenza Creative Commons 
                            ed è attualmente disponibile con licenza Free Download, che ne permette il download e la copia in forma completamente gratuita. 
                            Il suo titolo è un riferimento alla frase Crimini contro l'umanità, in allusione al suo contenuto politicamente scorretto.
                        </p>--%>
                                <p class="paragraph p3">
                                    CAH - Online refers to
                            <a class="link" href="https://cardsagainsthumanity.com">Cards Against Humanity</a>,an American board game, based on the sarcasm and
                             irony of his own players. The game takes advantage of the Creative Commons and is currently available with license Free Download, 
                             which allows downloading and copying completely free of charge. Its title is a reference to the sentence Crimes against humanity, 
                             in allusion to his politically incorrect content.
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card-panel-text">
                                <%--<h1 class="h1-text">La nascita del gioco<br />
                            <br />
                        </h1>--%>
                                <h1 class="h1-text">The birth of the game<br />
                                    <br />
                                </h1>
                                <%--<p class="paragraph p3">
                            Il gioco è stato creato da un gruppo di studenti della scuola superiore di Highland Park, 
                            nell'Illinois, per celebrare la festa di capodanno e fu finanziato attraverso il sito web 
                            <a class="link" href="https://www.kickstarter.com">Kickstarter</a>, 
                            superando l'obiettivo prefissato di quasi il 300%. Ben Hantoot, uno dei creatori, dichiarò che lo sviluppo del 
                            gioco era in larga parte dovuto a: "8 di noi che fummo il nucleo di creatori e scrittori, 5 o 6 collaboratori occasionali 
                            e decine di amici e conoscenti che hanno giocato al gioco".
                        </p>--%>
                                <p class="paragraph p3">
                                    The game was created by a group of high school students from Highland Park, Illinois, to celebrate the New Year's celebration 
                            and was funded through the <a class="link" href="https://www.kickstarter.com">Kickstarter</a>,  website, surpassing its target by almost 300 %. 
                            Ben Hantoot, one of the creators, said that the game's development was largely due to: "8 of us who were the nucleus of the creators and writers,
                            5 or 6 occasional contributors and dozens of friends and acquaintances who have played the game" .
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="row">
                        <asp:LinkButton ID="SelectButton" runat="server" CssClass="btn btn-start-play" Height="55px" OnClick="SelectButton_Click"><p class="btn-p">Start a new game
                    <i class="material-icons right icon-play">play_arrow</i></p> 
                        </asp:LinkButton>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="position3">
                        <div id="wrapper">
                            <ul id="index_cards">
                                <li id="card-1" class="empty-cards black">
                                    <p class="p-cards">
                                        What did I bring <br />
                                        back from <br /> 
                                        Mexico?
                                    </p>
                                </li>
                                <li id="card-11" class="empty-cards white">
                                    <asp:Label ID="lblCardWhite" runat="server" CssClass="p-cards"></asp:Label>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>

