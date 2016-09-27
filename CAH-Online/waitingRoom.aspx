<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    int indexRoom;
    int NumberUsers;
    Room room = new Room();
    bool stateChanged = false;
    int totalSeconds = 0;
    int seconds = 0;
    int minutes = 0;
    string time = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
        if (FunctionsDB.checkUserInGame(Master.resultUser))
        {
            if (room.listUserIsFull(indexRoom))
            {
                FunctionsDB.UpdateMatchesPlayed(Master.resultUser);
                Response.Redirect("~/game.aspx");
            }
        }
        if (!Page.IsPostBack)
        {
            stateChanged = true;
            Session["time1"] = 15;
            Session["time2"] = 1;
            //FunctionsDB.UpadateIsPlaying(Master.resultUser, 1);
            
            //int isUserExit = FunctionsDB.UserExit(Master.resultUser);
            //if(isUserExit == 1)
            //{
            //    string script = "alert(\"There are not enough players waiting to start a game!\");";
            //    ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
            //    Timer1.Enabled = false;
            //    Timer1.Dispose();
            //    Timer2.Enabled = true;
            //}
        }
        if(stateChanged)
        {
            Game.NewGame(Master.resultUser);
            stateChanged = false;
        }
    }

    protected void Timer1_Tick(object sender, EventArgs e)
    {
        Session["time1"] = Convert.ToInt16(Session["time1"]) - 1;
        if (Convert.ToInt16(Session["time1"]) <= 0)
        {
            indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
            NumberUsers = FunctionsDB.ReadUsersInRoom(indexRoom);

            if (room.listUserIsFull(indexRoom))
            {
                FunctionsDB.UpdateMatchesPlayed(Master.resultUser);
                Response.Redirect("~/game.aspx");
            }
            else
            {
                //string script = "alert(\"Non ci sono abbastanza giocatori in attesa di iniziare una partita!\");";
                string script = "alert(\"There are not enough players waiting to start a game!\");";
                ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);

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
                }
                Timer1.Enabled = false;
                Timer1.Dispose();
                Timer2.Enabled = true;
            }
        }
        else
        {
            //Label2.Text = time5.Minutes.ToString() + ":" + time5.Seconds.ToString();
            totalSeconds = Convert.ToInt16(Session["time1"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
        }
    }

    protected void Timer2_Tick(object sender, EventArgs e)
    {
        Session["time2"] = Convert.ToInt16(Session["time2"]) - 1;
        totalSeconds = Convert.ToInt16(Session["time2"]);
        seconds = totalSeconds % 60;
        minutes = totalSeconds / 60;
        time = minutes + ":" + seconds;
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
            if (FunctionsDB.CheckUserExit(indexRoom, Master.resultUser))
            {
                FunctionsDB.DeleteUserExit(Master.resultUser);
            }
            FunctionsDB.DeleteUserExit(Master.resultUser);
        }
        Response.Redirect("~/index.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" type="text/css" href="css/Cards.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:Timer ID="Timer1" runat="server" Interval="1000" OnTick="Timer1_Tick"></asp:Timer>
        <asp:Timer ID="Timer2" runat="server" Interval="1000" OnTick="Timer2_Tick" Enabled="False"></asp:Timer>
        <asp:Timer ID="Timer3" runat="server" Interval="1000" Enabled="False"></asp:Timer>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="container">
                <div class="row">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-16">
                                <div class="card-panel-x">
                                    <div class="row">
                                        <%--<div class="col-md-8">
                                            <h3 style="color: #FFFFFF">Attendere altri giocatori …</h3>
                                        </div>--%>
                                        <div class="col-md-10">
                                            <h3 style="color: #FFFFFF">Waiting for other players …</h3>
                                        </div>
                                    </div>
                                    <div class="progress wait">
                                        <div class="indeterminate"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="position3">
                    <div id="wrapper">
                        <ul id="index_cards">
                            <li id="card-1" class="empty-cards black">
                                <p class="p-cards">
                                    ______+______=<br />
                                    ___________.
                                </p>
                            </li>
                            <li id="card-2" class="empty-cards white">
                                <p class="p-cards">Raptor attacks.</p>
                            </li>
                            <li id="card-3" class="empty-cards white">
                                <p class="p-cards">The terrorists</p>
                            </li>
                            <li id="card-4" class="empty-cards white">
                                <p class="p-cards">Oompa-<br />
                                    Loompas.</p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>

