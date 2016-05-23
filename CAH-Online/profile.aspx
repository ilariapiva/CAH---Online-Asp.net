<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>


 <script runat="server">
 
     Account result;

     protected void Page_Load(object sender, EventArgs e)
     {
         Room room = new Room();
         if (room.ExistUserInRoom(Master.resultUser))
         {
             int indexRoom = room.ReturnKeyRoomUser(Master.resultUser);

             if (room.CheckDeleteCardsUser(Master.resultUser))
             {
                 room.DeleteCardsUser(Master.resultUser);
             }
             if (room.CheckDeleteUser(indexRoom, Master.resultUser))
             {
                 room.DeleteUser(indexRoom, Master.resultUser);
             }
             if (room.CheckDeleteCardsBlcak(indexRoom))
             {
                 room.DeleteCardBlack(indexRoom);
             }
             if (room.CheckDeleteKeyRoom(indexRoom))
             {
                 room.DeleteRoomInListUsers(indexRoom);
             }
             if (Game.CheckDeleteRoom(indexRoom))
             {
                 Game.DeleteRoom(indexRoom);
             }
             if (FunctionsDB.CheckRoom(indexRoom))
             {
                 FunctionsDB.DeleteRoomDB(indexRoom);
             }
         }
         
         //FunctionsDB.OpenConnectionDB();
         //Leggo dalla tabella account lo username, partite vinte, partite perse e partite giocate
         result = FunctionsDB.ReadValuesProfileDB();
         lblMatchesPlayed.Text = Convert.ToString(result.MatchesPlayed);
         lblMatchesWon.Text = Convert.ToString(result.MatchesWon);
         lblMatchesMissed.Text = Convert.ToString(result.MatchesMissed);
         lblMatchesEqualized.Text = Convert.ToString(result.MatchesEqualized);
         lblUsername.Text = result.Username;
         lblEmail.Text = Session["userEmail"].ToString();
     }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="flat-form-profile">
            <div class="form-action-profile">
                <h1 class="h1">Profile</h1>
                <p class="p5">
                    Qui puoi vedere i tuoi risultati.
                </p>
                <div class="form-horizontal form-text">
                    <ul>
                        <li class="form-control-static p4">E-mail:
                            <asp:Label class="control-label label-form" ID="lblEmail" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Username:
                            <asp:Label class="control-label label-form" ID="lblUsername" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Matches played:
                            <asp:Label class="control-label label-form" ID="lblMatchesPlayed" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Matches won:
                            <asp:Label class="control-label label-form" ID="lblMatchesWon" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Matches missed:
                            <asp:Label class="control-label label-form" ID="lblMatchesMissed" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Matches equalized:
                            <asp:Label class="control-label label-form" ID="lblMatchesEqualized" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
