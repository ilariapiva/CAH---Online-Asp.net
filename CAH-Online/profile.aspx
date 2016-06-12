<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

 <script runat="server">
 
     Account result;
     Room room = new Room();

     protected void Page_Load(object sender, EventArgs e)
     {
         if (!FunctionsDB.ExistCookies())
         {     
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
             FunctionsDB.DeleteCookies(Master.resultUser);
             Response.Redirect("~/login.aspx");
         }
         else
         {
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

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="Server">
     <%--<link rel="stylesheet" type="text/css" href="css/Style.css" />--%>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="row">
            <div class="col-md-16">
                <div class="card-panel-profile">
                    <div class="div-profile">
                        <h2 class="h1-text">Profile</h2>
                        <%--<h5 class="h5-text">Qui puoi trovare tutti i tuoi dati.</h5>--%>
                        <h5 class="h5-text">Here you can find all your data.</h5>
                        <div style="margin-top: 75px">
                            <asp:Label ID="Label1" runat="server" Text="E-mail address:" CssClass="profile-x"></asp:Label>
                            <asp:Label ID="lblEmail" runat="server" CssClass="control-label email-lbl"></asp:Label>
                        </div>
                        <div style="margin-top: 25px">
                            <asp:Label ID="Label2" runat="server" Text="Username:" CssClass="profile-x"></asp:Label>
                            <asp:Label CssClass="control-label username-lbl" ID="lblUsername" runat="server"></asp:Label>
                        </div>
                        <div style="margin-top: 25px">
                            <asp:Label ID="Label3" runat="server" Text="Matches played:" CssClass="profile-x"></asp:Label>
                            <asp:Label CssClass="control-label matchesPlayed-lbl" ID="lblMatchesPlayed" runat="server"></asp:Label>
                        </div>
                        <div style="margin-top: 25px">
                            <asp:Label ID="Label4" runat="server" Text="Matches won:" CssClass="profile-x"></asp:Label>
                            <asp:Label CssClass="control-label matchesWon-lbl" ID="lblMatchesWon" runat="server"></asp:Label>
                        </div>
                        <div style="margin-top: 25px">
                            <asp:Label ID="Label6" runat="server" Text="Matches missed:" CssClass="profile-x"></asp:Label>
                            <asp:Label CssClass="control-label matchesMissed-lbl" ID="lblMatchesMissed" runat="server"></asp:Label>
                        </div>
                        <div style="margin-top: 25px">
                            <asp:Label ID="Label8" runat="server" Text="Matches equalized:" CssClass="profile-x"></asp:Label>
                            <asp:Label CssClass="control-label matchesEqualized-lbl" ID="lblMatchesEqualized" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
