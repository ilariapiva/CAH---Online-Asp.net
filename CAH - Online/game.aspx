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

        if (!Page.IsPostBack)
        {
            stateChanged = true;
            Session["time"] = 100; //definisco tempo per il conteggio alla rovescia. Il tempo stabilito è di 1 min e 40 sec
        }

        if (stateChanged)
        {
            //recupero l'id della room
            indexRoom = FunctionsDB.GetRoom(Master.resultUser);

            //assegno l'idRoom
            room = Game.UserEntered(indexRoom);

            //se l'utente è il master visualizzo solo la carta master 
            if (Room.IsMaster(Master.resultUser))
            {
                CheckBox1.Visible = false;
                CheckBox2.Visible = false;
                CheckBox3.Visible = false;
                CheckBox4.Visible = false;
                CheckBox5.Visible = false;
                CheckBox6.Visible = false;
                CheckBox7.Visible = false;
                CheckBox8.Visible = false;
                CheckBox9.Visible = false;
                CheckBox10.Visible = false;

                btnConfirmCardSelect.Visible = false;

                blackCard = Room.GetCardBlack();
                lblBlack.Attributes.Add("value", blackCard.idCards.ToString());
                lblBlack.Text = blackCard.Text;
                
                
            }

            //se l'utente nella stanza non è il master allora visualizzo la carta nera e le carte bianche
            if (!Room.IsMaster(Master.resultUser))
            {
                btnConfirmWinner.Visible = false;

                blackCard = Room.GetCardBlack();
                lblBlack.Attributes.Add("value", blackCard.idCards.ToString());
                lblBlack.Text = blackCard.Text;

                whiteCards = Room.GetNewCardsWhite();

                /* lblWhite1.Attributes.Add("value", whiteCards[0].idCards.ToString());
                 lblWhite1.Text = whiteCards[0].Text;*/

                btnWhite1.Attributes.Add("value", whiteCards[0].idCards.ToString());
                btnWhite1.Text = whiteCards[0].Text;

                btnWhite2.Attributes.Add("value", whiteCards[1].idCards.ToString());
                btnWhite2.Text = whiteCards[1].Text;

                btnWhite3.Attributes.Add("value", whiteCards[2].idCards.ToString());
                btnWhite3.Text = whiteCards[2].Text;

                btnWhite4.Attributes.Add("value", whiteCards[3].idCards.ToString());
                btnWhite4.Text = whiteCards[3].Text;

                btnWhite5.Attributes.Add("value", whiteCards[4].idCards.ToString());
                btnWhite5.Text = whiteCards[4].Text;

                btnWhite6.Attributes.Add("value", whiteCards[5].idCards.ToString());
                btnWhite6.Text = whiteCards[5].Text;

                btnWhite7.Attributes.Add("value", whiteCards[6].idCards.ToString());
                btnWhite7.Text = whiteCards[6].Text;

                btnWhite8.Attributes.Add("value", whiteCards[7].idCards.ToString());
                btnWhite8.Text = whiteCards[7].Text;

                btnWhite9.Attributes.Add("value", whiteCards[8].idCards.ToString());
                btnWhite9.Text = whiteCards[8].Text;

                btnWhite10.Attributes.Add("value", whiteCards[9].idCards.ToString());
                btnWhite10.Text = whiteCards[9].Text;
            }

            stateChanged = false;
        }
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


    protected void btnConfirmCardSelect_Click(object sender, EventArgs e)
    {
        List<Cards> CardsSelect = new List<Cards>();
        Account User = Master.resultUser;

        /*Controllo se ogni checkBox è stata selezionata, e se è stata selezionata 
          allora inserisco l'id della carta in una lista*/
        if (CheckBox1.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite1.Text;
            c.idCards = Convert.ToInt32(btnWhite1.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox2.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite2.Text;
            c.idCards = Convert.ToInt32(btnWhite2.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox3.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite3.Text;
            c.idCards = Convert.ToInt32(btnWhite3.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox4.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite4.Text;
            c.idCards = Convert.ToInt32(btnWhite4.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox5.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite5.Text;
            c.idCards = Convert.ToInt32(btnWhite5.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox6.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite6.Text;
            c.idCards = Convert.ToInt32(btnWhite6.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox7.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite7.Text;
            c.idCards = Convert.ToInt32(btnWhite7.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox8.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite8.Text;
            c.idCards = Convert.ToInt32(btnWhite8.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox9.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite9.Text;
            c.idCards = Convert.ToInt32(btnWhite9.Attributes["value"]);
            CardsSelect.Add(c);
        }
        if (CheckBox10.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite10.Text;
            c.idCards = Convert.ToInt32(btnWhite10.Attributes["value"]);
            CardsSelect.Add(c);
        }

        Room.UsersAndCards(CardsSelect, indexRoom);

        btnConfirmCardSelect.Enabled = false;
    }

    protected void btnConfirmWinner_Click(object sender, EventArgs e)
    {

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
                        <asp:Button ID="btnWhite1" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <!--<div class="card-container">
                            <div class="white-card">
                               
                                <asp:HyperLink ID="lblWhite1" runat="server" CssClass="text-white"></asp:HyperLink>
                            </div>

                        </div>-->
                        <div class="username-card">
                            <asp:Label ID="lblUser1" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox1" runat="server" />
                        </div>

                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite2" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser2" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox2" runat="server" />
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite3" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser3" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox3" runat="server" />
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite4" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser4" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox4" runat="server" />
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite5" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser5" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox5" runat="server" />
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite6" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser6" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox6" runat="server" />
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite7" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser7" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox7" runat="server" />
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite8" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser8" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox8" runat="server" />
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite9" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser9" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox9" runat="server" />
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <asp:Button ID="btnWhite10" CssClass="card-container white-card text-white" runat="server" Text="" />
                        <div class="username-card">
                            <asp:Label ID="lblUser10" runat="server" Text="Label"></asp:Label>
                            <asp:CheckBox ID="CheckBox10" runat="server" />
                        </div>
                    </div>
                <asp:Button ID="btnConfirmCardSelect" runat="server" Text="Conferma" OnClick="btnConfirmCardSelect_Click" />
                <asp:Button ID="btnConfirmWinner" runat="server" Text="Conferma" OnClick="btnConfirmWinner_Click" />
            </div>
        </div>
    </div>
    </div>
</asp:Content>
