<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    int indexRoom;
    int NumberUsers;
    Room room = new Room();
    bool stateChanged = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
        if(room.listUserIsFull(indexRoom))
        {
            FunctionsDB.UpdateMatchesPlayed(Master.resultUser);
            Response.Redirect("~/game.aspx");
        }
        if (!Page.IsPostBack)
        {
            stateChanged = true;
            Session["time1"] = DateTime.Now.AddSeconds(15);
        }
        if(stateChanged)
        {
            Game.NewGame(Master.resultUser);
            stateChanged = false;
        }
    }

    protected void Timer1_Tick(object sender, EventArgs e)
    {
        TimeSpan time1 = new TimeSpan();
        time1 = (DateTime)Session["time1"] - DateTime.Now;
        if (time1.Seconds <= 0)
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
                string script = "alert(\"Non ci sono abbastanza giocatori in attesa di iniziare una partita!\");";
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
                } 
                Response.Redirect("~/index.aspx");
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:Timer ID="Timer1" runat="server" Interval="1000" OnTick="Timer1_Tick"></asp:Timer>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row">
                <div class="col-md-4">
                    <p style="color: #FFFFFF">Attendere, altri giocatori …</p>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
                <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
            </Triggers>
    </asp:UpdatePanel>
</asp:Content>

