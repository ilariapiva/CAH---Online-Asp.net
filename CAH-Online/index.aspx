
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
            Session["time1"] = 9000;
            Session["time2"] = 1;
            
            //FunctionsDB.UpadateIsPlaying(Master.resultUser, 0);
            if (room.ExistUserInRoom(Master.resultUser))
            {
                indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
                if(FunctionsDB.CheckUserExit(indexRoom, Master.resultUser))
                {
                     FunctionsDB.UpdateUserExit(Master.resultUser);
                }
            }
            GenerateCardsWhite();
        }
        
        if (!FunctionsDB.ExistCookies())
        {
            SelectButton.Enabled = false;
        }
        //else
        //{
        //    FunctionsDB.UpadateIsPlaying(Master.resultUser, 0);
        //}
        //else
        //{
        //    if (room.ExistUserInRoom(Master.resultUser))
        //    {
        //        indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
        //        FunctionsDB.UpdateUserExit(Master.resultUser);
        //        FunctionsDB.UpadateIsPlaying(Master.resultUser, 0);
                
        //        if (room.CheckDeleteCardsUser(Master.resultUser))
        //        {
        //            room.DeleteCardsUser(Master.resultUser);
        //        }
        //        if (room.CheckDeleteUser(indexRoom, Master.resultUser))
        //        {
        //            room.DeleteUser(indexRoom, Master.resultUser);
        //        }
        //        if (FunctionsDB.CheckUserInGame(indexRoom, Master.resultUser))
        //        {
        //            FunctionsDB.DeleteUserInGame(indexRoom, Master.resultUser);
        //        }
        //        if (FunctionsDB.CheckCardsUser(indexRoom, Master.resultUser))
        //        {
        //            FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
        //        }
        //        if (FunctionsDB.CheckDeleteCardsWhite(indexRoom, Master.resultUser))
        //        {
        //            FunctionsDB.DeleteCardsWhite(indexRoom, Master.resultUser);
        //        }
        //        if (FunctionsDB.CheckDeleteCardsBlack(indexRoom))
        //        {
        //            FunctionsDB.DeleteCardsBlack(indexRoom);
        //        }
        //    }
        //}
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
        if (Convert.ToInt16(Session["time1"]) <= 0)
        {
            Response.Redirect("~/index.aspx");
        }
        else
        {
            totalSeconds = Convert.ToInt16(Session["time1"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
            GenerateCardsWhite();
        }
    }

    protected void SelectButton_Click(object sender, EventArgs e)
    {
        //FunctionsDB.UpdateUserExit(Master.resultUser);
        
        int userIsPlaying = FunctionsDB.isPlaying(Master.resultUser);
        if (userIsPlaying == 1)
        {
            int idRoom = room.ReturnKeyRoomUser(Master.resultUser);
            if (room.listUserIsFull(idRoom))
            {
                indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
                if (FunctionsDB.CheckUserExit(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteUserExit(Master.resultUser);
                }
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
                    FunctionsDB.DeleteUserInGame(Master.resultUser);
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
                FunctionsDB.UpadateIsPlaying(Master.resultUser, 0);
                //string script = "alert(\"Non ci sono abbastanza giocatori in attesa di iniziare una partita!\");";
                string script = "alert(\"There was an error, please try again!\");";
                ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                Timer1.Enabled = false;
                Timer1.Dispose();
                Timer2.Enabled = true;
            }
            else
            {
                indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
                if (FunctionsDB.CheckUserExit(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteUserExit(Master.resultUser);
                }
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
                    FunctionsDB.DeleteUserInGame(Master.resultUser);
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
                FunctionsDB.UpadateIsPlaying(Master.resultUser, 0);
                Response.Redirect("~/waitingRoom.aspx");
            }
        }
        else
        {
            if (room.ExistUserInRoom(Master.resultUser))
            {
                indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
                if (FunctionsDB.CheckUserExit(indexRoom, Master.resultUser))
                {
                    int userIsExit = FunctionsDB.UserExit(Master.resultUser);
                    if (userIsExit == 1)
                    {
                        FunctionsDB.DeleteUserExit(Master.resultUser);
                        FunctionsDB.UpadateIsPlaying(Master.resultUser, 0);

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
                            FunctionsDB.DeleteUserInGame(Master.resultUser);
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
                        FunctionsDB.DeleteUserExit(Master.resultUser);
                        Response.Redirect("~/waitingRoom.aspx");
                    }
                }
            }
            else
            {
                FunctionsDB.DeleteUserExit(Master.resultUser);
                FunctionsDB.DeleteUserInGame(Master.resultUser);
                Response.Redirect("~/waitingRoom.aspx");
            }
        }
    }

    protected void Timer2_Tick(object sender, EventArgs e)
    {
        Session["time2"] = Convert.ToInt16(Session["time2"]) - 1;
        if (Convert.ToInt16(Session["time2"]) <= 0)
        {
            Response.Redirect("~/index.aspx");
        }
        else
        {
            totalSeconds = Convert.ToInt16(Session["time2"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
        }
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
            <asp:Timer ID="Timer2" runat="server" Interval="1000" OnTick="Timer2_Tick" Enabled="False" />
            <div class="row">
                <div class="col-md-6">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card-panel-text">
                                <h1 class="h1-text">Game Description<br />
                                    <br />
                                </h1>
                                <p class="paragraph p3">
                                    CAH - Online refers to <a class="link" href="https://cardsagainsthumanity.com" target="_blank">Cards Against Humanity</a>, an American board game. 
                                    This game is based on the sarcasm and the irony of the phrases created by the players. 
                                    CAH uses the Creative Commons license and is also available with a free license.
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card-panel-text">
                                <h1 class="h1-text">The birth of the game<br />
                                    <br />
                                </h1>
                                <p class="paragraph p3">
                                    Cards Against Humanity, whose title is a reference to politically incorrect content, has been created by some students of the high school Highlander Park, Illinois. 
                                    This game has been funded through the website <a class="link" href="https://www.kickstarter.com" target="_blank">Kickstarter</a> and the funding goal has been exceeded three times the target.
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

