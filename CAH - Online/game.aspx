<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
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

        if (stateChanged)
        {
            lblUser1.Visible = false;
            lblUser2.Visible = false;
            lblUser3.Visible = false;
            lblUser4.Visible = false;
            lblUser5.Visible = false;
            lblUser6.Visible = false;
            lblUser7.Visible = false;
            lblUser8.Visible = false;
            lblUser9.Visible = false;
            lblUser10.Visible = false;
            
            //recupero l'id della room
            indexRoom = FunctionsDB.GetRoom(Master.resultUser);

            //assegno l'idRoom
            room = Game.UserEntered(indexRoom);

            lblWhite1.Visible = false;
            lblWhite2.Visible = false;
            lblWhite3.Visible = false;
            lblWhite4.Visible = false;
            lblWhite5.Visible = false;
            lblWhite6.Visible = false;
            lblWhite7.Visible = false;
            lblWhite8.Visible = false;
            lblWhite9.Visible = false;
            lblWhite10.Visible = false;   
            
            if (room.IsMaster(Master.resultUser))
            {
                blackCard = room.GetCardBlack();
                lblBlack.Attributes.Add("value", blackCard.idCards.ToString());
                lblBlack.Text = blackCard.Text;            
            }

            if (!room.IsMaster(Master.resultUser))
            {
                lblWhite1.Visible = true;
                lblWhite2.Visible = true;
                lblWhite3.Visible = true;
                lblWhite4.Visible = true;
                lblWhite5.Visible = true;
                lblWhite6.Visible = true;
                lblWhite7.Visible = true;
                lblWhite8.Visible = true;
                lblWhite9.Visible = true;
                lblWhite10.Visible = true;   
                
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
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <asp:Timer ID="Timer" runat="server" Interval="1000" OnTick="Timer1_Tick"></asp:Timer>
        </div>
        <asp:UpdatePanel ID="Pannello" runat="server" UpdateMode="Conditional">
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
                                <asp:HyperLink ID="lblWhite1" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser1" runat="server" Text="Label"></asp:Label> 
                                <asp:CheckBox ID="CheckBox1" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite2" runat="server" CssClass="text-white"></asp:HyperLink>  
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser2" runat="server" Text="Label"></asp:Label>
                                <asp:CheckBox ID="CheckBox2" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite3" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser3" runat="server" Text="Label"></asp:Label>
                                <asp:CheckBox ID="CheckBox3" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite4" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser4" runat="server" Text="Label"></asp:Label>
                                <asp:CheckBox ID="CheckBox4" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite5" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser5" runat="server" Text="Label"></asp:Label>
                                <asp:CheckBox ID="CheckBox5" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite6" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser6" runat="server" Text="Label"></asp:Label>
                                <asp:CheckBox ID="CheckBox6" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite7" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser7" runat="server" Text="Label"></asp:Label>
                                <asp:CheckBox ID="CheckBox7" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite8" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser8" runat="server" Text="Label"></asp:Label>
                                <asp:CheckBox ID="CheckBox8" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite9" runat="server" CssClass="text-white"></asp:HyperLink>  
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser9" runat="server" Text="Label"></asp:Label>
                                <asp:CheckBox ID="CheckBox9" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:HyperLink ID="lblWhite10" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>
                            <div class="username-card">
                                <asp:Label ID="lblUser10" runat="server" Text="Label"></asp:Label>
                                 <asp:CheckBox ID="CheckBox10" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
