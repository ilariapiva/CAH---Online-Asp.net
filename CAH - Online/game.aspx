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
        lblUser11.Visible = false;
        lblUser12.Visible = false;
        lblUser13.Visible = false;
        lblUser14.Visible = false;
        lblUser15.Visible = false;
        lblUser16.Visible = false;
        lblUser17.Visible = false;
        lblUser18.Visible = false;
        lblUser19.Visible = false;
        lblUser20.Visible = false;

        btnWhite11.Visible = false;
        btnWhite12.Visible = false;
        btnWhite13.Visible = false;
        btnWhite14.Visible = false;
        btnWhite15.Visible = false;
        btnWhite16.Visible = false;
        btnWhite17.Visible = false;
        btnWhite18.Visible = false;
        btnWhite19.Visible = false;
        btnWhite20.Visible = false;

        CheckBox11.Visible = false;
        CheckBox12.Visible = false;
        CheckBox13.Visible = false;
        CheckBox14.Visible = false;
        CheckBox15.Visible = false;
        CheckBox16.Visible = false;
        CheckBox17.Visible = false;
        CheckBox18.Visible = false;
        CheckBox19.Visible = false;
        CheckBox20.Visible = false;

        if (!Page.IsPostBack)
        {
            stateChanged = true;
            Session["time1"] = 20; //definisco tempo per il conteggio alla rovescia. Il tempo stabilito è di 1 min e 40 sec
            Session["time2"] = 20;
            /* 100 = 1 min e 40 sec
             * 90 = 1 min 30 sec
             * 50 = 50 sec
             */
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
                lblTimer.Visible = false;
                
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
                lblTimerMaster.Visible = false;
                
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
        Session["time1"] = Convert.ToInt16(Session["time1"]) - 1;
        if (Convert.ToInt16(Session["time1"]) <= 0)
        {
            lblTimer.Text = "TimeOut!";

            if (Room.IsMaster(Master.resultUser))
            {
                lblTimerMaster.Visible = true;

                Session["time2"] = Convert.ToInt16(Session["time2"]) - 1;
                if (Convert.ToInt16(Session["time2"]) <= 0)
                {
                    lblTimerMaster.Text = "TimeOut!";
                    //insert_result();
                    //Response.Redirect("Show_result.aspx");
                }

                else
                {
                    totalSeconds = Convert.ToInt16(Session["time2"]);
                    seconds = totalSeconds % 60;
                    minutes = totalSeconds / 60;
                    time = minutes + ":" + seconds;
                    lblTimerMaster.Text = time;
                }

                if (Room.CheckUserCardSelected(indexRoom))
                {
                    CheckBox1.Visible = true;
                    CheckBox2.Visible = true;
                    CheckBox3.Visible = true;
                    CheckBox4.Visible = true;
                    CheckBox5.Visible = true;
                    CheckBox6.Visible = true;
                    CheckBox7.Visible = true;
                    CheckBox8.Visible = true;
                    CheckBox9.Visible = true;
                    CheckBox10.Visible = true;

                    lblUser1.Visible = true;
                    lblUser2.Visible = true;
                    lblUser3.Visible = true;
                    lblUser4.Visible = true;
                    lblUser5.Visible = true;
                    lblUser6.Visible = true;
                    lblUser7.Visible = true;
                    lblUser8.Visible = true;
                    lblUser9.Visible = true;
                    lblUser10.Visible = true;
                }
            }

            //insert_result();
            //Response.Redirect("Show_result.aspx");
        }

        else
        {
            totalSeconds = Convert.ToInt16(Session["time1"]);
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
            btnWhite1.Text = "";
        }
        if (CheckBox2.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite2.Text;
            c.idCards = Convert.ToInt32(btnWhite2.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite2.Text = "";
        }
        if (CheckBox3.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite3.Text;
            c.idCards = Convert.ToInt32(btnWhite3.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite3.Text = "";
        }
        if (CheckBox4.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite4.Text;
            c.idCards = Convert.ToInt32(btnWhite4.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite4.Text = "";
        }
        if (CheckBox5.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite5.Text;
            c.idCards = Convert.ToInt32(btnWhite5.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite5.Text = "";
        }
        if (CheckBox6.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite6.Text;
            c.idCards = Convert.ToInt32(btnWhite6.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite6.Text = "";
        }
        if (CheckBox7.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite7.Text;
            c.idCards = Convert.ToInt32(btnWhite7.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite7.Text = "";
        }
        if (CheckBox8.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite8.Text;
            c.idCards = Convert.ToInt32(btnWhite8.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite8.Text = "";
        }
        if (CheckBox9.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite9.Text;
            c.idCards = Convert.ToInt32(btnWhite9.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite9.Text = "";
        }
        if (CheckBox10.Checked)
        {
            Cards c = new Cards();
            c.Text = btnWhite10.Text;
            c.idCards = Convert.ToInt32(btnWhite10.Attributes["value"]);
            CardsSelect.Add(c);
            btnWhite10.Text = "";
        }
        Room.UsersAndCards(CardsSelect, indexRoom);

        //btnConfirmCardSelect.Enabled = false;
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
            <asp:Timer ID="Timer1" runat="server" Interval="1000" OnTick="Timer1_Tick"></asp:Timer>
        </div>
        <asp:UpdatePanel ID="Pannello" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Label ID="lblTimer" runat="server"></asp:Label>
                <asp:Label ID="lblTimerMaster" runat="server"></asp:Label>
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
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite11" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser11" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox11" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite12" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser12" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox12" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite13" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser13" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox13" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite14" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser14" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox14" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite15" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser15" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox15" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite16" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser16" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox16" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite17" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser17" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox17" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite18" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser18" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox18" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite19" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser19" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox19" runat="server" />
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite20" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser20" runat="server" Text="Label"></asp:Label>
                                    <asp:CheckBox ID="CheckBox20" runat="server" />
                                </div>
                            </div>
                            <asp:Button ID="btnConfirmWinner" runat="server" Text="Conferma" OnClick="btnConfirmWinner_Click" />
                        </div>
                    </div>
                </div>  
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</asp:Content>
