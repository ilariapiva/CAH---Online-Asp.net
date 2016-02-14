<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">
    
    int indexRoom;
    Room room;
    Cards blackCard;
    List<Cards> whiteCards = new List<Cards>();
    bool stateChanged;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            stateChanged = true;
            Session["time"] = 100; //definisco tempo per il conteggio alla rovesca. Il tempo stabilito è di 1 min e 40 sec
        }
        
        if(stateChanged)
        {
            //recupero l'id della room
            indexRoom = FunctionsDB.GetRoom(Master.resultUser);

            //assegno l'idRoom
            room = Game.UserEntered(indexRoom);

            if (room.IsMaster(Master.resultUser))
            {
                blackCard = room.GetCardBlack();
                lblBlack.Attributes.Add("value", blackCard.idCards.ToString());
                lblBlack.Text = blackCard.Text;
            }

            if (!room.IsMaster(Master.resultUser))
            {
                blackCard = room.GetCardBlack();
                lblBlack.Attributes.Add("value", blackCard.idCards.ToString());
                lblBlack.Text = blackCard.Text;
                
                whiteCards = room.GetNewCardsWhite();

                lblWhite1.Attributes.Add("value", whiteCards[0].idCards.ToString());
                lblWhite1.Text = whiteCards[0].Text;

                lblWhite2.Attributes.Add("value", whiteCards[1].idCards.ToString());
                lblWhite2.Text = whiteCards[1].Text;

                lblWhite3.Attributes.Add("value", whiteCards[2].idCards.ToString());
                lblWhite3.Text = whiteCards[2].Text;

                lblWhite4.Attributes.Add("value", whiteCards[3].idCards.ToString());
                lblWhite4.Text = whiteCards[3].Text;

                lblWhite5.Attributes.Add("value", whiteCards[4].idCards.ToString());
                lblWhite5.Text = whiteCards[4].Text;

                lblWhite6.Attributes.Add("value", whiteCards[5].idCards.ToString());
                lblWhite6.Text = whiteCards[5].Text;

                lblWhite7.Attributes.Add("value", whiteCards[6].idCards.ToString());
                lblWhite7.Text = whiteCards[6].Text;

                lblWhite8.Attributes.Add("value", whiteCards[7].idCards.ToString());
                lblWhite8.Text = whiteCards[7].Text;

                lblWhite9.Attributes.Add("value", whiteCards[8].idCards.ToString());
                lblWhite9.Text = whiteCards[8].Text;

                lblWhite10.Attributes.Add("value", whiteCards[9].idCards.ToString());
                lblWhite10.Text = whiteCards[9].Text;
            }

            stateChanged = false;
        }
        
        /*
        //prendo tutte le carte dalla tabella BlackCard e le inserisco in una lista
        Random rndBlackCard = new Random();
        
        String BlackCard = "SELECT * FROM tblBlackCard";
        List<Cards> cardBlack = FunctionsDB.Cards(BlackCard);
        
        List<Cards> RandomCardBlack = new List<Cards>();
        RandomCardBlack = (cardBlack.OrderBy(x => rndBlackCard.Next()).Take(1)).ToList();
        
        lblBlack.Text = RandomCardBlack[0].Text;


        //prendo tutte le carte dalla tabella WhiteCard e le inserisco in una lista
        Random rndWhiteCards = new Random();
        
        String WhiteCards = "SELECT * FROM tblWhiteCard";
        List<Cards> cardsWhite = FunctionsDB.Cards(WhiteCards);
        
        List<Cards> RandomCardsWhite = new List<Cards>();
        RandomCardsWhite = (cardsWhite.OrderBy(x => rndWhiteCards.Next()).Take(11)).ToList();

        lblWhite1.Text = RandomCardsWhite[0].Text;
        lblWhite2.Text = RandomCardsWhite[1].Text;
        lblWhite3.Text = RandomCardsWhite[2].Text;
        lblWhite4.Text = RandomCardsWhite[3].Text;
        lblWhite5.Text = RandomCardsWhite[4].Text;
        lblWhite6.Text = RandomCardsWhite[5].Text;
        lblWhite7.Text = RandomCardsWhite[6].Text;
        lblWhite8.Text = RandomCardsWhite[7].Text;
        lblWhite9.Text = RandomCardsWhite[8].Text;
        lblWhite10.Text = RandomCardsWhite[9].Text;
        lblWhite11.Text = RandomCardsWhite[10].Text;     */ 
        
        /*//scrivo nella carta nera una frase random presa dalla tabella carte nere
        String BlackCard = "SELECT TOP 1 * FROM tblBlackCard ORDER BY NEWID()";
        
        Cards blackCard = FunctionsDB.RadomCardBlack(BlackCard);

        //scrivo nelle carte bianche una frase random prese dalla tabella carte bianche
        String WhiteCards = "SELECT TOP 11 * FROM tblWhiteCard ORDER BY NEWID()";

        List<Cards> cards = FunctionsDB.RadomCardWhite(WhiteCards);
        */
        
    }

    //serve per il conteggio alla rovescia
    
    int totalSeconds = 0;
    int seconds = 0;
    int minutes = 0;
    string time = "";
    
    protected void Timer1_Tick(object sender, EventArgs e)
    {
        Session["time"] = Convert.ToInt16(Session["time"]) - 1;
        if (Convert.ToInt16(Session["time"]) <= 0)
        {

            lblTimer.Text = "TimeOut!";
            //insert_result();
            //Response.Redirect("Show_result.aspx");
        }

        else
        {
            totalSeconds = Convert.ToInt16(Session["time"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
            lblTimer.Text = time;
        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="css/game.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container game-container">
        <p>&nbsp;</p>
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <asp:Timer ID="Timer" runat="server" Interval ="1000" OnTick="Timer1_Tick"></asp:Timer>
        </div>
        <asp:UpdatePanel ID="Pannello" runat="server" UpdateMode ="Conditional">
            <ContentTemplate>
                <asp:Label ID="lblTimer" runat="server"></asp:Label>
            </ContentTemplate>    
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="Timer" EventName="Tick" />
            </Triggers>
        </asp:UpdatePanel>
        <div class="row">
            <div class="col-md-3">
                <div class="card-black-container">
                    <div class="black-card">
                         <asp:Label ID="lblBlack" runat="server"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="row">
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite1" runat="server"></asp:Label>
                            </div>
                            <!--<div class="username-card">
                                <p>Matteo</p>
                            </div>-->
                        </div>
                    </div>
                     <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite2" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite3" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite4" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite5" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite6" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite7" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite8" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite9" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite10" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>